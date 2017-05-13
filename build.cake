
Task("Build").Does(() => {
    StartProcess("stack", new ProcessSettings {
        Arguments = "build --copy-bins"
    });
});

Task("Run").Does(() => {

});

var target = Argument("target", "default");
RunTarget(target);