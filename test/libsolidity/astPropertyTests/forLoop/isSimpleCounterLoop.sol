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
        // Positive Cases
        /// SimplePreIncrement: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
        }
        /// SimplePosIncrement: isSimpleCounterLoop
        for(int i = 0; i < 42; i++) {
        }
        uint x;
        /// CounterReadLoopBody: isSimpleCounterLoop
        for(uint i = 0; i < 42; i++) {
            x = i;
        }
        /// LocalVarConditionRHS: isSimpleCounterLoop
        for(uint i = 0; i < x; i++) {
        }
        uint[8] memory array;
        /// StaticArrayLengthConditionRHS: isSimpleCounterLoop
        for(uint i = 0; i < array.length; i++) {
        }
        dynArray.push();
        /// DynamicArrayLengthConditionRHS: isSimpleCounterLoop
        for(uint i = 0; i < dynArray.length; i++) {
            dynArray.push(i);
        }
        /// CounterReadInlineAssembly: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            assembly {
                x := i
            }
        }
        /// BinaryOperationConditionRHS: isSimpleCounterLoop
        for(uint i = 0; i < i + 1; i++) {
        }
        /// FreeFunctionConditionRHS: isSimpleCounterLoop
        for(uint i = 0; i < h(); ++i) {
        }
        // Negative Cases
        /// AdditionLoopExpression: isSimpleCounterLoop
        for(uint i = 0; i < 42; i = i + 1) {
        }
        /// SimplePreDecrement: isSimpleCounterLoop
        for(uint i = 42; i > 0; --i) {
        }
        /// SimplePosDecrement: isSimpleCounterLoop
        for(uint i = 42; i > 0; i--) {
        }
        /// MultiplicationLoopExpression: isSimpleCounterLoop
        for(uint i = 1; i < 42; i = i * 2) {
        }
        /// CounterIncrementLoopBody: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            i++;
        }
        /// CounterAssignmentLoopBody: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            i = 43;
        }
        /// CounterAssignmentInlineAssemblyLoopBody: isSimpleCounterLoop
        for(uint i = 0; i < 42; ++i) {
            assembly {
                i := add(i, 1)
            }
        }
        uint j = type(uint).max;
        /// ExternalCounterLoopExpression: isSimpleCounterLoop
        for (uint i = 0; i < 10; ++j) {
        }
        /// CounterIncrementRHSAssignment: isSimpleCounterLoop
        for(uint i = 0; i < 10; ++i) {
            x = i++;
        }
        /// NoEffectLoopExpression: isSimpleCounterLoop
        for(uint i = 0; i < 42; i) {
        }
        /// EmptyLoopExpression: isSimpleCounterLoop
        for(uint i = 0; i < 10; ) {
        }
        uint y = type(uint8).max + 1;
        /// DifferentCommonTypeCondition: isSimpleCounterLoop
        for(uint8 i = 0; i < y; ++i) {
        }
        /// LessThanOrEqualCondition: isSimpleCounterLoop
        for(uint i = 0; i <= 10; ++i) {
        }
        /// ComplexExpressionCondition: isSimpleCounterLoop
        for(uint i = 0; (i < 10 || g()); ++i) {
        }
        /// FreeFunctionConditionLHS: isSimpleCounterLoop
        for(uint i = 0; h() < 100; ++i) {
        }
        /// FreeFunctionConditionDifferentCommonTypeLHS: isSimpleCounterLoop
        for(uint8 i = 0; i < h(); ++i) {
        }
        /// NonIntegerTypeCondition: isSimpleCounterLoop
        for(uint i = 0; address(this) < msg.sender; ++i) {
        }
        /// UDVTOperators: isSimpleCounterLoop
        for(UINT i = UINT.wrap(0); i < UINT.wrap(10); i = i + UINT.wrap(1)) {
        }
        /// CounterAssignmentConditionRHS: isSimpleCounterLoop
        for(uint i = 0; i < (i = i + 1); ++i) {
        }
        /// LiteralDifferentCommonTypeConditionRHS: isSimpleCounterLoop
        for(uint8 i = 0; i < 257 ; ++i) {
        }
        /// StateVarCounterModifiedFunctionConditionRHS: isSimpleCounterLoop
        for (z = 1; z < modifyStateVarZ(); ++z) {
        }
        /// StateVarCounterModifiedFunctionLoopBody: isSimpleCounterLoop
        for (z = 1; z < 2048; ++z) {
            modifyStateVarZ();
        }
        /// NonIntegerCounter: isSimpleCounterLoop
        for (address i = address(0x123); i < address(this); i = address(0x123 + 1)) {
        }
    }
}
// ----
// SimplePreIncrement: true
// SimplePosIncrement: true
// CounterReadLoopBody: true
// LocalVarConditionRHS: true
// StaticArrayLengthConditionRHS: true
// DynamicArrayLengthConditionRHS: true
// CounterReadInlineAssembly: true
// BinaryOperationConditionRHS: true
// FreeFunctionConditionRHS: true
// AdditionLoopExpression: false
// SimplePreDecrement: false
// SimplePosDecrement: false
// MultiplicationLoopExpression: false
// CounterIncrementLoopBody: false
// CounterAssignmentLoopBody: false
// CounterAssignmentInlineAssemblyLoopBody: false
// ExternalCounterLoopExpression: false
// CounterIncrementRHSAssignment: false
// NoEffectLoopExpression: false
// DifferentCommonTypeCondition: false
// EmptyLoopExpression: false
// LessThanOrEqualCondition: false
// ComplexExpressionCondition: false
// FreeFunctionConditionLHS: false
// FreeFunctionConditionDifferentCommonTypeLHS: false
// NonIntegerTypeCondition: false
// UDVTOperators: false
// CounterAssignmentConditionRHS: true
// LiteralDifferentCommonTypeConditionRHS: false
// StateVarCounterModifiedFunctionConditionRHS: true
// StateVarCounterModifiedFunctionLoopBody: true
// NonIntegerCounter: false
