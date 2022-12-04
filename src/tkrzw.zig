const c = @cImport({
    @cInclude("../tkrzw/tkrzw_langc.h");
});

pub fn free(s: []u8) void {
    c.free(s.ptr);
}

pub const DBM = struct {
    ptr: *c.TkrzwDBM,

    const This = @This();

    pub fn open(path: [:0]const u8, writable: bool, params: [:0]const u8) ?This {
        return if (c.tkrzw_dbm_open(path.ptr, writable, params.ptr)) |ptr|
            This{
                .ptr = ptr,
            }
        else
            null;
    }

    pub fn close(this: This) bool {
        return c.tkrzw_dbm_close(this.ptr);
    }

    pub fn set(this: This, key: []const u8, value: []const u8, overwrite: bool) bool {
        return c.tkrzw_dbm_set(this.ptr, key.ptr, @intCast(i32, key.len), value.ptr, @intCast(i32, value.len), overwrite);
    }

    /// remember to free the result
    pub fn get(this: This, key: []const u8) ?[]u8 { // todo: change fn sig to error{NOT_FOUND}![]const u8
        var value_len: i32 = 0;
        var maybe_value_ptr = c.tkrzw_dbm_get(this.ptr, key.ptr, @intCast(i32, key.len), &value_len);
        return if (maybe_value_ptr) |value_ptr|
            value_ptr[0..@intCast(usize, value_len)]
        else
            null;
    }

    pub fn make_iterator(this: This) DBMIter {
        return DBMIter { .ptr = c.tkrzw_dbm_make_iterator(this.ptr) };
    }
};

pub const DBMIter = struct {
    ptr: *c.TkrzwDBMIter,
    
    const This = @This();
    
    pub fn deinit(this: This) void {
        c.tkrzw_dbm_iter_free(this.ptr);
    }

    pub fn first(this: This) bool {
        return c.tkrzw_dbm_iter_first(this.ptr);
    }
    pub fn last(this: This) bool {
        return c.tkrzw_dbm_iter_last(this.ptr);
    }
    pub fn next(this: This) bool {
        return c.tkrzw_dbm_iter_next(this.ptr);
    }
    pub fn previous(this: This) bool {
        return c.tkrzw_dbm_iter_previous(this.ptr);
    }

    /// remember to free key&value
    pub fn get(this: This, key: *[]u8, value: *[]u8) bool {
        var key_len: i32 = undefined;
        var value_len: i32 = undefined;
        const res = c.tkrzw_dbm_iter_get(this.ptr,
            @ptrCast(*[*c]u8, &key.ptr), &key_len,
            @ptrCast(*[*c]u8, &value.ptr), &value_len);
        if (res) {
            key.len = @intCast(usize, key_len);
            value.len = @intCast(usize, value_len);
        }
        return res;
    }
};
