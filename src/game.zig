const rl = @import("raylib");
const Spaceship = @import("spaceship.zig");
const Self = @This();

spaceship_spritesheet: rl.Texture2D,
laserbolt_spritesheet: rl.Texture2D,
spaceship: Spaceship,
top_left_bound_point: rl.Vector2,
bottom_left_bound_point: rl.Vector2,
top_right_bound_point: rl.Vector2,
bottom_right_bound_point: rl.Vector2,

pub fn init() Self {
    const screen_height: f32 = @floatFromInt(rl.getScreenHeight());
    const screen_width: f32 = @floatFromInt(rl.getScreenWidth());
    const spaceship_spritesheet = rl.loadTexture("resources/assets/ship.png");
    const laserbolt_spritesheet = rl.loadTexture("resources/assets/laser-bolts.png");

    return .{
        .spaceship_spritesheet = spaceship_spritesheet,
        .laserbolt_spritesheet = laserbolt_spritesheet,
        .spaceship = Spaceship.init(spaceship_spritesheet, laserbolt_spritesheet),
        .bottom_left_bound_point = .{ .x = 0, .y = screen_height },
        .top_right_bound_point = .{ .x = screen_width, .y = 0 },
        .top_left_bound_point = .{ .x = 0, .y = 0 },
        .bottom_right_bound_point = .{ .x = screen_width, .y = screen_height },
    };
}

pub fn deinit(self: Self) void {
    self.spaceship_spritesheet.unload();
    self.laserbolt_spritesheet.unload();
}

pub fn draw(self: Self) void {
    rl.beginDrawing();
    rl.clearBackground(rl.Color.dark_blue);
    self.spaceship.draw();
    rl.endDrawing();
}

pub fn update(self: *Self) void {
    self.spaceship.update();
}

pub fn handleInputs(self: *Self) void {
    if (rl.isKeyDown(rl.KeyboardKey.key_up)) {
        self.spaceship.moveUp();
    }
    if (rl.isKeyDown(rl.KeyboardKey.key_down)) {
        self.spaceship.moveDown();
    }
    if (rl.isKeyDown(rl.KeyboardKey.key_left)) {
        self.spaceship.moveLeft();
    }
    if (rl.isKeyDown(rl.KeyboardKey.key_right)) {
        self.spaceship.moveRight();
    }
    if (rl.isKeyPressed(rl.KeyboardKey.key_space)) {
        self.spaceship.fireLaser();
    }
}
