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

package org.fao.geonet.services.harvesting;

import java.sql.SQLException;
import java.util.Iterator;
import jeeves.constants.Jeeves;
import jeeves.resources.dbms.Dbms;
import jeeves.server.context.ServiceContext;
import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.kernel.harvest.Common.OperResult;
import org.fao.geonet.kernel.harvest.HarvestManager;
import org.jdom.Attribute;
import org.jdom.Element;

//=============================================================================

public class Util
{
	//--------------------------------------------------------------------------
	//---
	//--- Job interface
	//---
	//--------------------------------------------------------------------------

	public interface Job
	{
		public OperResult execute(Dbms dbms, HarvestManager hm, String id) throws SQLException;
	}

	//--------------------------------------------------------------------------
	//---
	//--- Exec service: executes the job on all input ids returning the status
	//---               for each one
	//---
	//--------------------------------------------------------------------------

	public static Element exec(Element params, ServiceContext context, Job job) throws Exception
	{
		GeonetContext  gc = (GeonetContext) context.getHandlerContext(Geonet.CONTEXT_NAME);
		HarvestManager hm = gc.getHarvestManager();

		Dbms dbms = (Dbms) context.getResourceManager().open(Geonet.Res.MAIN_DB);

		Iterator i = params.getChildren().iterator();

		Element response = new Element(Jeeves.Elem.RESPONSE);

		while (i.hasNext())
		{
			Element el  = (Element) i.next();
			String  id  = el.getText();
			String  res = job.execute(dbms, hm, id).toString();

			el = new Element("id")
							.setText(id)
							.setAttribute(new Attribute("status", res));

			response.addContent(el);
		}

		return response;
	}
}

//=============================================================================

