pub mod memsearch;
pub mod mmbnlc;

use mlua::prelude::*;

#[mlua::lua_module]
fn patch(lua: &Lua) -> LuaResult<LuaValue> {
    let text_section = lua
        .globals()
        .get::<_, LuaTable>("chaudloader")?
        .get::<_, LuaTable>("GAME_ENV")?
        .get::<_, LuaTable>("sections")?
        .get::<_, LuaTable>("text")?;
    let text_address = text_section.get::<_, LuaInteger>("address")? as usize;
    let text_size = text_section.get::<_, LuaInteger>("size")? as usize;

    // Remove resolution check
    let addr = memsearch::find_n_in(
        "|4057 4883EC40 48C7442420FEFFFFFF 48895C2450 4889742458 418BF8 8BF2 488BD9",
        text_address,
        text_size,
        1,
    )
    .expect("Cannot find resolution check function")[0];
    println!("Overriding resolution check function @ {addr:#X}");
    std::mem::forget(unsafe {
        ilhook::x64::Hooker::new(
            addr,
            ilhook::x64::HookType::Retn(on_check_resolution),
            ilhook::x64::CallbackOption::None,
            0,
            ilhook::x64::HookFlags::empty(),
        )
        .hook()
        .expect("Cannot hook resolution check function")
    });

    let mut found = false;
    for addr in memsearch::Query::build("488B08 488B01 FF9010010000 84C0|7460")
        .unwrap()
        .iter_matches_in(text_address, text_size)
    {
        found = true;
        println!("Removing Steam Deck check @ {addr:#X}");

        // Change JZ (0x74) instruction to JMP (0xEB)
        unsafe {
            *(addr as *mut u8) = 0xEB;
        }
    }
    if !found {
        panic!("Cannot find Steam Deck check");
    }

    Ok(LuaValue::Nil)
}

unsafe extern "win64" fn on_check_resolution(
    _regs: *mut ilhook::x64::Registers,
    _ori_func_ptr: usize,
    _user_data: usize,
) -> usize {
    // Always return true
    true.into()
}
