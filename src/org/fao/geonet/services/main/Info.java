//=============================================================================
//===	Copyright (C) 2001-2007 Food and Agriculture Organization of the
//===	United Nations (FAO-UN), United Nations World Food Programme (WFP)
//===	and United Nations Environment Programme (UNEP)
//===
//===	This program is free software; you can redistribute it and/or modify
//===	it under the terms of the GNU General Public License as published by
//===	the Free Software Foundation; either version 2 of the License, or (at
//===	your option) any later version.
//===
//===	This program is distributed in the hope that it will be useful, but
//===	WITHOUT ANY WARRANTY; without even the implied warranty of
//===	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//===	General Public License for more details.
//===
//===	You should have received a copy of the GNU General Public License
//===	along with this program; if not, write to the Free Software
//===	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
//===
//===	Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
//===	Rome - Italy. email: geonetwork@osgeo.org
//==============================================================================

package org.fao.geonet.services.main;

import java.sql.SQLException;
import java.util.Iterator;
import jeeves.exceptions.BadParameterEx;
import jeeves.interfaces.Service;
import jeeves.resources.dbms.Dbms;
import jeeves.server.ServiceConfig;
import jeeves.server.context.ServiceContext;
import jeeves.utils.Xml;
import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.lib.Lib;
import org.jdom.Element;

//=============================================================================

public class Info implements Service
{
	private String xslPath;

	//--------------------------------------------------------------------------
	//---
	//--- Init
	//---
	//--------------------------------------------------------------------------

	public void init(String appPath, ServiceConfig config) throws Exception
	{
		xslPath = appPath + Geonet.Path.STYLESHEETS+ "/xml";
	}

	//--------------------------------------------------------------------------
	//---
	//--- Service
	//---
	//--------------------------------------------------------------------------

	public Element exec(Element params, ServiceContext context) throws Exception
	{
		GeonetContext gc = (GeonetContext) context.getHandlerContext(Geonet.CONTEXT_NAME);

		Dbms dbms = (Dbms) context.getResourceManager().open(Geonet.Res.MAIN_DB);

		Element result = new Element("root");

		for (Iterator i=params.getChildren().iterator(); i.hasNext();)
		{
			Element el = (Element) i.next();

			String name = el.getName();
			String type = el.getText();

			if (!name.equals("type"))
				throw new BadParameterEx(name, type);

			if (type.equals("site"))
				result.addContent(gc.getSettingManager().get("system", -1));

			else if (type.equals("categories"))
				result.addContent(Lib.local.retrieve(dbms, "Categories"));

			else if (type.equals("groups"))
				result.addContent(Lib.local.retrieve(dbms, "Groups"));

			else if (type.equals("operations"))
				result.addContent(Lib.local.retrieve(dbms, "Operations"));

			else if (type.equals("regions"))
				result.addContent(Lib.local.retrieve(dbms, "Regions"));

			else if (type.equals("knownNodes"))
				result.addContent(getKnownNodes(dbms));

			else if (type.equals("harvestingNodes"))
				result.addContent(getHarvestingNodes(dbms));

			else
				throw new BadParameterEx("type", type);
		}

		result.addContent(getEnv(context));

		return Xml.transform(result, xslPath +"/info.xsl");
	}

	//--------------------------------------------------------------------------
	//---
	//--- Private methods
	//---
	//--------------------------------------------------------------------------

	private Element getKnownNodes(Dbms dbms) throws SQLException
	{
		Element result = dbms.select("SELECT * FROM KnownNodes ORDER BY name");

		Iterator i = result.getChildren().iterator();

		while (i.hasNext())
		{
			Element record = (Element) i.next();
			record.getChild("siteid").setName("siteId");
		}

		return result.setName("knownNodes");
	}

	//--------------------------------------------------------------------------

	private Element getHarvestingNodes(Dbms dbms) throws SQLException
	{
		String query = "SELECT name, source, count(*) as num "+
							"FROM   Metadata, KnownNodes "+
							"WHERE  source=siteId "+
							"GROUP BY source";

		return dbms.select(query).setName("harvestingNodes");
	}

	//--------------------------------------------------------------------------

	private Element getEnv(ServiceContext context)
	{
		return new Element("env")
						.addContent(new Element("baseURL").setText(context.getBaseUrl()));
	}
}

//=============================================================================

