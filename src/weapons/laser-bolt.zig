const rl = @import("raylib");

pub const Laserbolt = struct {
    const Self = @This();

    spritesheet: rl.Texture2D,
    sprite_rect: rl.Rectangle,
    position: rl.Vector2,
    speed: f32 = 6.0,
    active: bool,

    pub fn init(spritesheet: rl.Texture2D) Self {
        return .{
            .spritesheet = spritesheet,
            .sprite_rect = rl.Rectangle.init(0, 0, 32, 24),
            .position = .{ .x = 0, .y = 0 },
            .active = false,
        };
    }

    pub fn update(self: *Self) void {
        if (!self.active) {
            return;
        }

        self.position.y -= self.speed;

        if (self.position.y + self.sprite_rect.height < 0) {
            self.active = false;
        }
    }

    pub fn draw(self: Self) void {
        if (!self.active) {
            return;
        }

        rl.drawTextureRec(self.spritesheet, self.sprite_rect, self.position, rl.Color.white);
    }
};

pub const Laserbolts = struct {
    const max_number_of_laserbolts = 3;
    laserbolts: [max_number_of_laserbolts]Laserbolt = undefined,
    amount_available: usize = max_number_of_laserbolts,

    const Self = @This();

    pub fn init(spritesheet: rl.Texture2D) Self {
        var laserbolts: [max_number_of_laserbolts]Laserbolt = undefined;

        inline for (0..max_number_of_laserbolts) |i| {
            laserbolts[i] = Laserbolt.init(spritesheet);
        }

        return .{ .laserbolts = laserbolts };
    }

    pub fn update(self: *Self) void {
        for (&self.laserbolts) |*laserbolt| {
            laserbolt.update();
        }
    }

    pub fn draw(self: Self) void {
        for (self.laserbolts) |laserbolt| {
            laserbolt.draw();
        }
    }

    pub fn updateAvailable(self: *Self) void {
        var new_amount_available: usize = 0;
        for (self.laserbolts) |laserbolt| {
            if (laserbolt.active) {
                continue;
            }
            new_amount_available += 1;
        }
        self.amount_available = new_amount_available;
    }

    pub fn fireLaser(self: *Self, player_pos: rl.Vector2, height_to_spawn: f32) void {
        for (&self.laserbolts) |*laserbolt| {
            if (laserbolt.active) {
                continue;
            }
            laserbolt.position.x = player_pos.x;
            laserbolt.position.y = height_to_spawn;
            laserbolt.active = true;
            self.amount_available -= 1;

            return;
        }
    }
};
