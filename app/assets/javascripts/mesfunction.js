var network;
var container;
var exportArea;
var importButton;
var exportButton;

	function init() {
		
        container = document.getElementById('network');
        exportArea = document.getElementById('input_output');
        importButton = document.getElementById('import_button');
        exportButton = document.getElementById('export_button');
			// draw();
    }

    function addConnections(elem, index) {
        // need to replace this with a tree of the network, then get child direct children of the element
        elem.connections = network.getConnectedNodes(index);
    }

    function destroyNetwork() {
       	network.destroy();
       	clearOutputArea();
    }

    function clearOutputArea() {
       exportArea.value = " ";
    }

    function draw() {
        // // create a network of nodes
        // var data = getData();
        // console.log(data);
        // network = new vis.Network(container, data, {manipulation:{enabled:true}});
        // clearOutputArea();
    }

    $(document).ready(function(){
        $('#topology-select').on('change', function(){
            var $this = $(this);
            var topology_id = $this.val();
            $.get("pages/graph/data/"+ topology_id, function (data) {
                network = new vis.Network(container, data, {manipulation:{enabled:true}});
                clearOutputArea();
            }, 'json')
        });
    });

            function exportNetwork() {
                clearOutputArea();

                var nodes = objectToArray(network.getPositions());

                nodes.forEach(addConnections);

                // pretty print node data
                var exportValue = JSON.stringify(nodes, undefined, 2);

                exportArea.value = exportValue;

                //resizeExportArea();
            }

            function importNetwork() {
                var inputValue = exportArea.value;
                var inputData = JSON.parse(inputValue);

                var data = {
                    nodes: getNodeData(inputData),
                    edges: getEdgeData(inputData)
                }

                network = new vis.Network(container, data, {});

               // resizeExportArea();
            }

            function getNodeData(data) {
                var networkNodes = [];

                data.forEach(function(elem, index, array) {
                    networkNodes.push({id: elem.id, label: elem.id, x: elem.x, y: elem.y});
                });

                return new vis.DataSet(networkNodes);
            }

            function getNodeById(data, id) {
                for (var n = 0; n < data.length; n++) {
                    if (data[n].id == id) {  // double equals since id can be numeric or string
                      return data[n];
                    }
                };

                throw 'Can not find id \'' + id + '\' in data';
            }

            function getEdgeData(data) {
                var networkEdges = [];

                data.forEach(function(node) {
                    // add the connection
                    node.connections.forEach(function(connId, cIndex, conns) {
                        networkEdges.push({from: node.id, to: connId});
                        let cNode = getNodeById(data, connId);

                        var elementConnections = cNode.connections;

                        // remove the connection from the other node to prevent duplicate connections
                        var duplicateIndex = elementConnections.findIndex(function(connection) {
                          return connection == node.id; // double equals since id can be numeric or string
                        });


                        if (duplicateIndex != -1) {
                          elementConnections.splice(duplicateIndex, 1);
                        };
                  });
                });

                return new vis.DataSet(networkEdges);
            }

            function objectToArray(obj) {
                return Object.keys(obj).map(function (key) {
                  obj[key].id = key;
                  return obj[key];
                });
            }

            //function resizeExportArea() {
            //	var num = 54;
             //   exportArea.style.height = num + "%";
           // }
           

function getScaleFreeNetwork(nodeCount) {
  var nodes = [];
  var edges = [];
  var connectionCount = [];

  // randomly create some nodes and edges
  for (var i = 0; i < nodeCount; i++) {
    nodes.push({
      id: i,
      label: String(i)
    });

    connectionCount[i] = 0;

    // create edges in a scale-free-network way
    if (i == 1) {
      var from = i;
      var to = 0;
      edges.push({
        from: from,
        to: to
      });
      connectionCount[from]++;
      connectionCount[to]++;
    }
    else if (i > 1) {
      var conn = edges.length * 2;
      var rand = Math.floor(Math.random() * conn);
      var cum = 0;
      var j = 0;
      while (j < connectionCount.length && cum < rand) {
        cum += connectionCount[j];
        j++;
      }

      var from = i;
      var to = j;
      edges.push({
        from: from,
        to: to
      });
      connectionCount[from]++;
      connectionCount[to]++;
    }
  }

  return {nodes:nodes, edges:edges};
}

