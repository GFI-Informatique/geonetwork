//=====================================================================================
//===
//=== Main harvesting class
//===
//=====================================================================================

ker.include('harvesting/harvester.js');
ker.include('harvesting/geonet/geonetwork.js');
ker.include('harvesting/geonet20/geonetwork20.js');
ker.include('harvesting/webdav/webdav.js');
ker.include('harvesting/model.js');
ker.include('harvesting/view.js');
ker.include('harvesting/util.js');

var harvesting = null;

//=====================================================================================

function init()
{
	harvesting = new Harvesting();
	
	//--- waits for all files to be loaded
	ker.loadMan.wait(harvesting);
}

//=====================================================================================

function Harvesting() 
{
	var loader = new XMLLoader(Env.locUrl +'/xml/harvesting.xml');
	var model  = new Model(loader);
	var view   = new View(loader);

	//--- create subsystems and register them

	var geonet   = new Geonetwork(loader);
	var geonet20 = new Geonetwork20(loader);
	var webdav   = new WebDav(loader);

	//--- public objects

	this.geonet   = geonet;
	this.geonet20 = geonet20;
	this.webdav   = webdav;

	//--- public methods

	this.init    = init;
	this.refresh = refresh;
	this.remove  = remove;
	this.start   = start;
	this.stop    = stop;
	this.run     = run;
	this.edit    = edit;
	this.update  = update;
	this.show    = show;
	this.newNode = newNode;
	
//=====================================================================================
//===
//=== API methods
//===
//=====================================================================================

function init()
{
	view.register(geonet);
	view.register(geonet20);
	view.register(webdav);
	view.show(SHOW.LIST);
	
	refresh();
	webdav.refreshGroups();
}

//=====================================================================================

function refresh()
{
	view.removeAll();
	model.getNodes(ker.wrap(this, refresh_OK));
}

//-------------------------------------------------------------------------------------

function refresh_OK(nodes)
{
	var entries = xml.children(nodes);
	
	//--- add all harvesting entries to list
	
	for (var i=0; i<entries.length; i++)
		view.append(entries[i]);
}

//=====================================================================================

function remove()
{
	var idList = view.getIdList();

	if (idList.length == 0)
		alert(loader.getText('pleaseSelect'));
	else
	{
		if (confirm(loader.getText('confirmRemove')) == false)
			return;
		
		model.removeNodes(idList, ker.wrap(this, remove_OK));
	}
}

//-------------------------------------------------------------------------------------

function remove_OK(idList)
{
	for (var i=0; i<idList.length; i++)
	{
		//--- if the status is not ok we ignore it. Maybe the entry has been already 
		//--- removed or maybe the id is simply wrong. In this case a simple refresh 
		//--- should be enough.
		
		view.remove(idList[i].ID);
	}
}

//=====================================================================================

function start()
{
	var idList = view.getIdList();

	if (idList.length == 0)
		alert(loader.getText('pleaseSelect'));
	else
		model.startNodes(idList, ker.wrap(this, start_OK));
}
	
//-------------------------------------------------------------------------------------

function start_OK(idList)
{
	for (var i=0; i<idList.length; i++)
	{
		var id     = idList[i].ID;
		var status = idList[i].STATUS;

		if (status == 'ok' || status=='already-active')
		{
			view.unselect(id);
			view.setStarted(id);
		}
	}
}

//=====================================================================================

function stop()
{
	var idList = view.getIdList();
	
	if (idList.length == 0)
		alert(loader.getText('pleaseSelect'));
	else
		model.stopNodes(idList, ker.wrap(this, stop_OK));
}

//-------------------------------------------------------------------------------------

function stop_OK(idList)
{
	for (var i=0; i<idList.length; i++)
	{
		var id     = idList[i].ID;
		var status = idList[i].STATUS;

		if (status == 'ok' || status=='already-inactive')
		{
			view.unselect(id);
			view.setStopped(id);
		}
	}
}

//=====================================================================================

function run()
{
	var idList = view.getIdList();
	
	if (idList.length == 0)
		alert(loader.getText('pleaseSelect'));
	else
		model.runNodes(idList, ker.wrap(this, run_OK));
}

//-------------------------------------------------------------------------------------

function run_OK(idList)
{
	for (var i=0; i<idList.length; i++)
	{
		var id     = idList[i].ID;
		var status = idList[i].STATUS;

		if (status == 'ok' || status=='already-running')
		{
			view.unselect(id);
			view.setRunning(id);
		}
	}
}

//=====================================================================================

function edit(id)
{
	model.getNode(id, ker.wrap(this, view.edit));
}

//=====================================================================================

function update()
{
	var request = view.getUpdateRequest();

	if (request == null)
		return;
			
	//--- send add/update request
	
	if (view.isAdding())	
		model.addNode(request, ker.wrap(this, update_OK));
	else
		model.updateNode(request, ker.wrap(this, update_OK));
}

//-------------------------------------------------------------------------------------

function update_OK(node)
{
	if (view.isAdding())		view.append(node);
		else						view.refresh(node);

	view.show(SHOW.LIST);
}

//=====================================================================================

function show(panel)
{
	view.show(panel);
}

//=====================================================================================

function newNode()
{
	view.newNode();
}

//=====================================================================================
}
