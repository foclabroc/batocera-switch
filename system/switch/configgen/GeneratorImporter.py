from __future__ import annotations

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from generators.Generator import Generator

# not the nicest way, possibly one of the faster i think
# some naming rules may allow to modify this function to less than 10 lines

def getGenerator(emulator: str) -> Generator:

    if emulator == 'eden':
        from generators.eden.edenGenerator import EdenGenerator
        return EdenGenerator()
    if emulator == 'citron':
        from generators.citron.citronGenerator import CitronGenerator
        return CitronGenerator()

    if emulator == 'sudachi':
        from generators.sudachi.sudachiGenerator import SudachiGenerator
        return SudachiGenerator()

    if emulator == 'yuzu-ea':
        from generators.yuzu.yuzuMainlineGenerator import YuzuMainlineGenerator
        return YuzuMainlineGenerator()

    if emulator == 'ryujinx-greem':
        from generators.ryujinx.ryujinxMainlineGenerator import RyujinxMainlineGenerator
        return RyujinxMainlineGenerator()

    raise Exception(f"no generator found for emulator {emulator}")
