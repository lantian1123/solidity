type UINT is uint;

function add(UINT x, UINT y) pure returns (UINT) {
    return UINT.wrap(UINT.unwrap(x) + UINT.unwrap(y));
}

function lt(UINT x, UINT y) pure returns (bool) {
    return UINT.unwrap(x) < UINT.unwrap(y);
}

using {lt as <, add as +} for UINT global;

function g() pure returns (bool) {
    return false;
}

function h() pure returns (uint) {
    return 13;
}

contract C {
    uint[] dynArray;
    uint z = 0;

    function modifyStateVarZ() public returns (uint) {
        z = type(uint).max;
        return z;
    }

    function f() public {
        /// PositiveCase1: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
        }
        /// PositiveCase2: isSimpleCounterLoop
        for(int i = 0; i < 42; i++) {
        }
        uint x;
        /// PositiveCase3: isSimpleCounterLoop
        for(uint i = 0; i < 42; i++) {
            x = i;
        }
        /// PositiveCase4: isSimpleCounterLoop
        for(uint i = 0; i < x; i++) {
        }
        uint[8] memory array;
        /// PositiveCase5: isSimpleCounterLoop
        for(uint i = 0; i < array.length; i++) {
        }
        dynArray.push();
        /// PositiveCase6: isSimpleCounterLoop
        for(uint i = 0; i < dynArray.length; i++) {
            dynArray.push(i);
        }
        /// PositiveCase7: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            assembly {
                x := i
            }
        }
        /// PositiveCase8: isSimpleCounterLoop
        for(uint i = 0; i < i + 1; i++) {
        }
        /// PositiveCase9: isSimpleCounterLoop
        for(uint i = 0; i < h(); ++i) {
        }
        /// NegativeCase1: isSimpleCounterLoop
        for(uint i = 0; i < 42; i = i + 1) {
        }
        /// NegativeCase2: isSimpleCounterLoop
        for(uint i = 42; i > 0; --i) {
        }
        /// NegativeCase3: isSimpleCounterLoop
        for(uint i = 42; i > 0; i--) {
        }
        /// NegativeCase4: isSimpleCounterLoop
        for(uint i = 1; i < 42; i = i * 2) {
        }
        /// NegativeCase5: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            i++;
        }
        /// NegativeCase6: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            i = 43;
        }
        /// NegativeCase7: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            assembly {
                i := add(i, 1)
            }
        }
        uint j = type(uint).max;
        /// NegativeCase8: isSimpleCounterLoop
        for (uint i = 0; i < 10; ++j) {
        }
        /// NegativeCase9: isSimpleCounterLoop
        for(uint i = 0; i < 10; ++i) {
            x = i++;
        }
        /// NegativeCase10: isSimpleCounterLoop
        for(uint i = 0; i < 42; i) {
        }
        uint y = type(uint8).max + 1;
        /// NegativeCase11: isSimpleCounterLoop
        for(uint8 i = 0; i < y; ++i) {
        }
        /// NegativeCase12: isSimpleCounterLoop
        for(uint i = 0; i < 10; ) {
        }
        /// NegativeCase13: isSimpleCounterLoop
        for(uint i = 0; i <= 10; ++i) {
        }
        /// NegativeCase14: isSimpleCounterLoop
        for(uint i = 0; (i < 10 || g()); ++i) {
        }
        /// NegativeCase15: isSimpleCounterLoop
        for(uint i = 0; h() < 100; ++i) {
        }
        /// NegativeCase16: isSimpleCounterLoop
        for(uint i = 0; address(this) < msg.sender; ++i) {
        }
        /// NegativeCase17: isSimpleCounterLoop
        for(UINT i = UINT.wrap(0); i < UINT.wrap(10); i = i + UINT.wrap(1)) {
        }
        /// NegativeCase18: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            i = 43;
        }
        /// NegativeCase19: isSimpleCounterLoop
        for(uint i = 0; i < (i = i + 1); ++i) {
        }
        /// NegativeCase20: isSimpleCounterLoop
        for(uint8 i = 0; i < 257 ; ++i) {
        }
        /// NegativeCase21: isSimpleCounterLoop
        for(uint8 i = 0; i < h(); ++i) {
        }
        /// NegativeCase22: isSimpleCounterLoop
        for (z = 1; z < modifyStateVarZ(); ++z) {
        }
        /// NegativeCase23: isSimpleCounterLoop
        for (address i = address(0x123); i < address(this); i = address(0x123 + 1)) {
        }
        uint16 w = 512;
        /// NegativeCase24: isSimpleCounterLoop
        for(uint8 i = 0; i < w; ++i) {
        }
        /// NegativeCase25: isSimpleCounterLoop
        for(uint8 i = 0; i < h(); ++i) {
        }
    }
}
// ----
// PositiveCase1: true
// PositiveCase2: true
// PositiveCase3: true
// PositiveCase4: true
// PositiveCase5: true
// PositiveCase6: true
// PositiveCase7: true
// PositiveCase8: true
// PositiveCase9: true
// NegativeCase1: false
// NegativeCase2: false
// NegativeCase3: false
// NegativeCase4: false
// NegativeCase5: false
// NegativeCase6: false
// NegativeCase7: false
// NegativeCase8: false
// NegativeCase9: false
// NegativeCase10: false
// NegativeCase11: false
// NegativeCase12: false
// NegativeCase13: false
// NegativeCase14: false
// NegativeCase15: false
// NegativeCase16: false
// NegativeCase17: false
// NegativeCase18: false
// NegativeCase19: true
// NegativeCase20: false
// NegativeCase21: false
// NegativeCase22: true
// NegativeCase23: false
// NegativeCase24: false
// NegativeCase25: false
