part of path_finding;

/// An implementation Dijkstra's pathfinding algorithm.
///
/// Based on the description of the algorithm found at:  
/// http://en.wikipedia.org/wiki/Dijkstra%27s_algorithm#Algorithm
class DijkstraFinder extends Finder {
  DijkstraFinder(Graph graph) : super(graph);

  List<Point> pathFind(Point startPoint, Point goalPoint) {
    Node start = this.graph.nodeFromPoint(startPoint);
    Node goal = this.graph.nodeFromPoint(goalPoint);

    Set<Node> Unvisited = new Set<Node>();

    Map<Node, Node> Came_From = new Map<Node, Node>();

    for (Node node in this.graph.allNodes) {
      node._f = double.INFINITY;
      Unvisited.add(node);
    }

    Node current = start;
    current._f = 0.0;

    while (Unvisited.isNotEmpty) {
      for (Node neighbor in this.graph.getNeighbors(current, onlyWalkable: true)) {
        if (!Unvisited.contains(neighbor)) {
          continue;
        }

        double tentative_distance = current._f + Heuristic.euclidean(current.location, neighbor.location);
        if (tentative_distance < neighbor._f) {
          neighbor._f = tentative_distance;
          Came_From[neighbor] = current;
        }
      }

      Unvisited.remove(current);

      // Goal node was visited
      if (!Unvisited.contains(goal)) {
        return _reconstruct_path(Came_From, current);
      } 

      Node nodeWithSmallestDistance = Unvisited.first;
      for (Node node in Unvisited) {
        if (node._f < nodeWithSmallestDistance._f) {
          nodeWithSmallestDistance = node;
        }
      }

      // No connection between start and goal nodes exists.
      if (nodeWithSmallestDistance._f == double.INFINITY) {
        return [];
      }

      current = nodeWithSmallestDistance;
    }

    return [];
  }

  List<Point> _reconstruct_path(Map<Node, Node> Came_From, Node current) {
    List<Point> totalPath = [current.location];

    while (Came_From.keys.contains(current)) {
      current = Came_From[current];
      totalPath.add(current.location);
    }

    return totalPath.reversed.toList();
  }
}