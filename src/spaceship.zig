const rl = @import("raylib");
const Self = @This();

spritesheet: rl.Texture2D,
sprite_rect: rl.Rectangle,
position: rl.Vector2,
comptime speed: f32 = 2.0,

pub fn init(spaceship_spritesheet: rl.Texture2D) Self {
    const screen_width: f32 = @floatFromInt(rl.getScreenWidth());
    const screen_height: f32 = @floatFromInt(rl.getScreenHeight());
    const position: rl.Vector2 = .{ .x = screen_width / 2.0, .y = screen_height / 2.0 };
    const sprite_height: f32 = @floatFromInt(spaceship_spritesheet.height);
    const sprite_width: f32 = @floatFromInt(spaceship_spritesheet.width);
    const sprite_rect = rl.Rectangle.init(0, 0, sprite_width, sprite_height);

    return .{
        .spritesheet = spaceship_spritesheet,
        .sprite_rect = sprite_rect,
        .position = position,
    };
}

pub fn update(self: Self) void {
    _ = self;
}

pub fn draw(self: Self) void {
    rl.drawTextureRec(self.spritesheet, self.sprite_rect, self.position, rl.Color.white);
}

pub fn moveUp(self: *Self) void {
    if (self.position.y - self.speed < 0) {
        return;
    }

    self.position.y -= self.speed;
}

pub fn moveDown(self: *Self) void {
    const screen_height: f32 = @floatFromInt(rl.getScreenHeight());
    const sprite_height: f32 = @floatFromInt(self.spritesheet.height);
    if (self.position.y + self.speed > screen_height - sprite_height) {
        return;
    }

    self.position.y += self.speed;
}

pub fn moveLeft(self: *Self) void {
    if (self.position.x - self.speed < 0) {
        return;
    }

    self.position.x -= self.speed;
}

pub fn moveRight(self: *Self) void {
    const screen_width: f32 = @floatFromInt(rl.getScreenWidth());
    const sprite_width: f32 = @floatFromInt(self.spritesheet.width);
    if (self.position.x + self.speed > screen_width - sprite_width) {
        return;
    }

    self.position.x += self.speed;
}
