const rl = @import("raylib");
const Laserbolt = @import("weapons/laser-bolt.zig").Laserbolt;
const Laserbolts = @import("weapons/laser-bolt.zig").Laserbolts;
const Self = @This();

spritesheet: rl.Texture2D,
sprite_rect: rl.Rectangle,
position: rl.Vector2,
speed: f32 = 2.0,
laserbolts: Laserbolts = undefined,

pub fn init(spaceship_spritesheet: rl.Texture2D, laserbolt_spritesheet: rl.Texture2D) Self {
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
        .laserbolts = Laserbolts.init(laserbolt_spritesheet),
    };
}

pub fn update(self: *Self) void {
    self.laserbolts.update();
    self.laserbolts.updateAvailable();
}

pub fn draw(self: Self) void {
    rl.drawTextureRec(self.spritesheet, self.sprite_rect, self.position, rl.Color.white);
    self.laserbolts.draw();
}

fn canMoveUp(self: *Self) bool {
    return self.position.y - self.speed > 0;
}

fn canMoveRight(self: *Self) bool {
    const screen_width: f32 = @floatFromInt(rl.getScreenWidth());
    const sprite_width: f32 = @floatFromInt(self.spritesheet.width);
    return self.position.x + self.speed < screen_width - sprite_width;
}

fn canMoveLeft(self: *Self) bool {
    return self.position.x - self.speed > 0;
}

fn canMoveDown(self: *Self) bool {
    const screen_height: f32 = @floatFromInt(rl.getScreenHeight());
    const sprite_height: f32 = @floatFromInt(self.spritesheet.height);
    return self.position.y + self.speed < screen_height - sprite_height;
}

pub fn moveUp(self: *Self) void {
    if (!self.canMoveUp()) {
        return;
    }

    self.position.y -= self.speed;
}

pub fn moveUpRight(self: *Self) void {
    if (!self.canMoveUp()) {
        return self.moveRight();
    } else if (!self.canMoveRight()) {
        return self.moveUp();
    }

    const normalized_speed = rl.math.normalize(self.speed, 0, self.speed);

    self.position.y -= normalized_speed;
    self.position.x += normalized_speed;
}

pub fn moveDownRight(self: *Self) void {
    if (!self.canMoveDown()) {
        return self.moveRight();
    } else if (!self.canMoveRight()) {
        return self.moveDown();
    }

    const normalized_speed = rl.math.normalize(self.speed, 0, self.speed);

    self.position.y += normalized_speed;
    self.position.x += normalized_speed;
}

pub fn moveUpLeft(self: *Self) void {
    if (!self.canMoveUp()) {
        return self.moveLeft();
    } else if (!self.canMoveLeft()) {
        return self.moveUp();
    }

    const normalized_speed = rl.math.normalize(self.speed, 0, self.speed);

    self.position.y -= normalized_speed;
    self.position.x -= normalized_speed;
}

pub fn moveDownLeft(self: *Self) void {
    if (!self.canMoveDown()) {
        return self.moveLeft();
    } else if (!self.canMoveLeft()) {
        return self.moveDown();
    }

    const normalized_speed = rl.math.normalize(self.speed, 0, self.speed);

    self.position.y += normalized_speed;
    self.position.x -= normalized_speed;
}

pub fn moveDown(self: *Self) void {
    if (!self.canMoveDown()) {
        return;
    }

    self.position.y += self.speed;
}

pub fn moveLeft(self: *Self) void {
    if (!self.canMoveLeft()) {
        return;
    }

    self.position.x -= self.speed;
}

pub fn moveRight(self: *Self) void {
    if (!self.canMoveRight()) {
        return;
    }

    self.position.x += self.speed;
}

pub fn fireLaser(self: *Self) void {
    if (self.laserbolts.amount_available <= 0) return;

    const sprite_height: f32 = @floatFromInt(self.spritesheet.height);
    const height_to_spawn = self.position.y - sprite_height / 2.0;
    self.laserbolts.fireLaser(self.position, height_to_spawn);
}
