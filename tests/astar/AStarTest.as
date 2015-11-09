package astar {
import org.flexunit.Assert;

public class AStarTest {

    private var astar:AStar;

    [Before(order=1)]
    public function before():void {
        astar = new AStar();
    }

    [After]
    public function runAfterEveryTest():void {
        astar = null;
    }

    [Test]
    public function constructorDefaultRadius():void {
        Assert.assertNotNull(astar);
    }

//    [Test]
//    public function constructorWithRadius():void {
//        astar = new AStar();
//        Assert.assertEquals(250, astar.radius);
//    }
//
//    [Test]
//    public function getAreaDefaultRadius():void {
//        assertThat(astar.area, closeTo(125663, 1));
//    }
}
}