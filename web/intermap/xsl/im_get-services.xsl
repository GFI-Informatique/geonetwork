<?xml version="1.0" encoding="UTF-8"?>
<?xmlspysamplexml D:\temp\WMS_Capabilities.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">
	
	<xsl:include href="main.xsl"/>
	
	<!-- Main template -->
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="/root/gui/strings/title"/>
				</title>
				<link rel="stylesheet" type="text/css" href="../../intermap.css"/>
				<script language="JavaScript" src="../../scripts/intermap.js"/>
				<script language="javascript">
				function getWmsLayerInfo(name) {
					window.open(('<xsl:value-of select="/root/gui/locService" />/map.service.wmsLayerInfo?url=<xsl:value-of select="/root/response/url"/>&amp;name=' + name).unescapeHTML(), 'dialog', 'HEIGHT=300,WIDTH=400,scrollbars=yes,toolbar=no,status=no,menubar=no,location=no,resizable=yes').focus();
				}
			</script>
			</head>
			<body>
				<xsl:call-template name="formLayout">
					<xsl:with-param name="title" select="/root/gui/strings/choosemapfromlist"/>
					<xsl:with-param name="content">
						<xsl:copy-of select="/root/gui/strings/feedbackTopics"/>
						<p/>
						<form action="{/root/gui/locService}/map.addServices" method="post" name="form">
							<table>
								<tr>
									<td>
										<xsl:apply-templates select="/root/response/ARCXML/RESPONSE/SERVICES"/>
										<!-- ArcIMS -->
										<xsl:apply-templates select="//WMT_MS_Capabilities/Service"/>
										<!-- WMS -->
										<xsl:apply-templates select="//Capability/Layer">
											<xsl:with-param name="first">true</xsl:with-param>
										</xsl:apply-templates>
									</td>
								</tr>
							</table>
							<input type="hidden" name="url" value="{/root/response/url}"/>
							<input type="hidden" name="type" value="{/root/response/type}"/>
						</form>
					</xsl:with-param>
					<xsl:with-param name="buttons">
						<button class="content" onclick="document.form.action='{/root/gui/locService}/map.getMain';document.form.submit();"><xsl:value-of select="/root/gui/strings/cancel"/></button>
						&#160;
						<button class="content" onclick="document.form.submit();"><xsl:value-of select="/root/gui/strings/ok"/></button>
					</xsl:with-param>
				</xsl:call-template>
			</body>
		</html>
	</xsl:template>
	
	<!-- ArcIMS Services -->
	<xsl:template match="/root/response/ARCXML/RESPONSE/SERVICES">
		<tr>
			<td>
				<b>
					<xsl:value-of select="count(SERVICE[@type='ImageServer'])"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="/root/gui/strings/mapsfound"/>
				</b>
			</td>
		</tr>
		<tr>
			<td>
				<select name="service" multiple="multiple" size="20">
					<xsl:for-each select="SERVICE[@type='ImageServer']">
						<xsl:sort select="@name"/>
						<option value="{@name}">
							<xsl:value-of select="@name"/>
						</option>
					</xsl:for-each>
				</select>
			</td>
		</tr>
	</xsl:template>
	
	<!-- WMS service informations -->
	<xsl:template match="//WMT_MS_Capabilities/Service">
		<h2>
			<xsl:value-of select="Title"/>
		</h2>
		<!-- Abstract -->
		<xsl:if test="Abstract">
			<p>
				<b>
					<xsl:value-of select="/root/gui/strings/abstract"/>
				</b>
				<xsl:text> </xsl:text>
				<xsl:value-of select="Abstract"/>
			</p>
		</xsl:if>
		<!-- Keywords -->
		<xsl:if test="KeywordList">
			<p>
				<b>
					<xsl:value-of select="/root/gui/strings/keywords"/>
				</b>
				<xsl:text> </xsl:text>
				<xsl:variable name="keywords">
					<xsl:for-each select="KeywordList/Keyword">
						<xsl:value-of select="."/>
						<xsl:text>, </xsl:text>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="substring($keywords, 1, string-length($keywords) - 2)"/>
			</p>
		</xsl:if>

		<!-- Online resource -->
		<p>
			<b>
				<xsl:value-of select="/root/gui/strings/homepage"/>
			</b>
			<xsl:text> </xsl:text>
			<xsl:variable name="geonetwork" select="OnlineResource/@xlink:href"/>
			<xsl:choose>
				<xsl:when test="contains($geonetwork,'geonetwork')">
					<a href="javascript:openGeoNetwork('{OnlineResource/@xlink:href}');">
						<xsl:value-of select="OnlineResource/@xlink:href"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<a href="javascript:openPage('{OnlineResource/@xlink:href}','Attribution');">
						<xsl:value-of select="OnlineResource/@xlink:href"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</p>

		<!-- Contact information -->
		<xsl:if test="ContactInformation">
			<p>
				<b>
					<xsl:value-of select="/root/gui/strings/contactInfo"/>
				</b>
				<br/>
				<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
				<!-- Contact person -->
				<xsl:if test="ContactInformation/ContactPersonPrimary/ContactPerson">
					<b>
						<xsl:value-of select="/root/gui/strings/contactPerson"/>
					</b>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ContactInformation/ContactPersonPrimary/ContactPerson"/>
				</xsl:if>
				<!-- Contact organization -->
				<xsl:if test="ContactInformation/ContactPersonPrimary/ContactOrganization">
				(<xsl:value-of select="ContactInformation/ContactPersonPrimary/ContactOrganization"/>)
			</xsl:if>
				<!-- Contact position -->
				<xsl:if test="ContactInformation/ContactPosition">
					<br/>
					<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
					<b>
						<xsl:value-of select="/root/gui/strings/position"/>
					</b>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ContactInformation/ContactPosition"/>
				</xsl:if>
				<!-- Contact address -->
				<xsl:if test="ContactInformation/ContactAddress">
					<br/>
					<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
					<b>
						<xsl:value-of select="/root/gui/strings/address"/>
					</b>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ContactInformation/ContactAddress/Address"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="ContactInformation/ContactAddress/City"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ContactInformation/ContactAddress/StateOrProvince"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ContactInformation/ContactAddress/PostCode"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ContactInformation/ContactAddress/Country"/>
				</xsl:if>
				<!-- Contact telephone -->
				<xsl:if test="ContactInformation/ContactVoiceTelephone">
					<br/>
					<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
					<b>
						<xsl:value-of select="/root/gui/strings/telephone"/>
					</b>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ContactInformation/ContactVoiceTelephone"/>
				</xsl:if>
				<!-- Contact fax -->
				<xsl:if test="ContactInformation/ContactFacsimileTelephone">
					<br/>
					<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
					<b>Fax:</b>
					<xsl:text> </xsl:text>
					<xsl:value-of select="ContactInformation/ContactFacsimileTelephone"/>
				</xsl:if>
				<!-- Contact email -->
				<xsl:if test="ContactInformation/ContactElectronicMailAddress">
					<br/>
					<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
					<b>
						<xsl:value-of select="/root/gui/strings/email"/>
					</b>
					<xsl:text> </xsl:text>
					<a>
						<xsl:attribute name="href"><xsl:text>mailto:</xsl:text><xsl:value-of select="ContactInformation/ContactElectronicMailAddress"/></xsl:attribute>
						<xsl:value-of select="ContactInformation/ContactElectronicMailAddress"/>
					</a>
				</xsl:if>
			</p>
		</xsl:if>
		<hr width="90%"/>
	</xsl:template>
	
	<!-- WMS Services -->
	<xsl:template match="Layer">
		<xsl:param name="first"/>
		<xsl:choose>
			<xsl:when test="$first='true'">
				<!-- First level -->
				<xsl:choose>
					<xsl:when test="not(Layer)">
						<!-- It's a layer -->
						<xsl:apply-templates select="." mode="title"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- It's a layer group -->
						<b>
							<xsl:value-of select="Title"/>
						</b>
						<ul>
							<xsl:apply-templates select="Layer">
								<!-- Recursively apply this template -->
								<xsl:with-param name="first" select="false"/>
							</xsl:apply-templates>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- Other levels -->
				<xsl:choose>
					<xsl:when test="not(Layer)">
						<!-- It's a layer -->
						<li>
							<xsl:apply-templates select="." mode="title"/>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<!-- It's a layer group -->
						<li class="layer_group">
							<xsl:choose>
								<xsl:when test="./Name">
									<b><xsl:apply-templates select="." mode="title"/></b>
								</xsl:when>
								<xsl:otherwise>
									<b><xsl:value-of select="Title"/></b>
								</xsl:otherwise>
							</xsl:choose>
						</li>
						<ul>
							<xsl:apply-templates select="Layer">
								<!-- Recursively apply this template -->
								<xsl:with-param name="first" select="false"/>
							</xsl:apply-templates>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- WMS layers title -->
	<xsl:template match="Layer" mode="title">
		<input type="checkbox" name="service" value="{Name}"></input>
		<xsl:value-of select="Title"/>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		<xsl:choose>
			<xsl:when test="MetadataURL">
			<xsl:variable name="met" select="MetadataURL/OnlineResource/@xlink:href"/>
			<xsl:choose>
				<xsl:when test="contains($met,'geonetwork')">
					<a>
						<xsl:attribute name="href">javascript:openGeoNetwork('<xsl:value-of select="MetadataURL/OnlineResource/@xlink:href"/>');</xsl:attribute>
						<xsl:value-of select="/root/gui/strings/metadata"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text>
					<a>
						<xsl:attribute name="href">javascript:openPage('<xsl:value-of select="MetadataURL/OnlineResource/@xlink:href"/>','Metadata');</xsl:attribute>
						<xsl:value-of select="/root/gui/strings/metadata"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:when>
			<xsl:when test="Abstract">
				<a href="javascript:getWmsLayerInfo('{Name}')">
					<img id="info" src="{/root/gui/url}/images/im_info.gif" />
				</a>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="Attribution">
			<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
			<xsl:choose>
				<xsl:when test="Attribution/OnlineResource | Attribution/LogoURL">
					<a>
						<xsl:attribute name="href">javascript:openPage('<xsl:value-of select="Attribution/OnlineResource/@xlink:href"/>','Attribution');</xsl:attribute>
						<img alt="{Attribution/Title}" src="{Attribution/LogoURL/OnlineResource/@xlink:href}" title="{Attribution/Title}"  border="0" align="middle" />
					</a>
				</xsl:when>
				<xsl:when test="Attribution/OnlineResource">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="Attribution/OnlineResource/@xlink:href"/>
						</xsl:attribute>
						<xsl:value-of select="Attribution/Title"/>
					</a>
				</xsl:when>
			</xsl:choose>
		</xsl:if>

	</xsl:template>
</xsl:stylesheet>
