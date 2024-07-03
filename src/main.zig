const std = @import("std");
const rl = @import("raylib");
const Game = @import("game.zig");

pub fn main() !void {
    rl.initWindow(800, 600, "Rocket Fighters");
    rl.setTargetFPS(144);
    defer rl.closeWindow();
    var game = Game.init();
    defer game.deinit();

    while (!rl.windowShouldClose()) {
        game.handleInputs();
        game.update();
        game.draw();
    }
}
