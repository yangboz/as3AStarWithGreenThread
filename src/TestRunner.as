package {
import flash.display.Sprite;

import org.flexunit.internals.TraceListener;
import org.flexunit.runner.FlexUnitCore;

import tests.AStarTest;

public class TestRunner extends Sprite {
    private var core:FlexUnitCore;


    public function TestRunner() {
        super();

        core = new FlexUnitCore();
        core.addListener(new TraceListener());
        core.run(AStarTest);

    }
}
}
