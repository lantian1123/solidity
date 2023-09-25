// fallback---------->f----------+
//                    |          |
//                    |          |
//                    |          |
//                    |          |
//                    v          v
//                    g          h
//
//
// add
//
// unreferenced

pragma experimental solidity;

type uint256 = __builtin("word");

instantiation uint256: + {
    function add(x, y) -> uint256 {
        let a = uint256.rep(x);
        let b = uint256.rep(y);
        assembly {
            a := add(a,b)
        }
        return uint256.abs(a);
    }
}

function unreferenced(x:uint256) -> uint256
{
    return x;
}

function f(x:uint256) -> uint256
{
    return g(h(x));
}

function g(x:uint256) -> uint256
{
    return x;
}

function h(x:uint256) -> uint256
{
    return x;
}

contract C {
    fallback() external {
        let a: uint256->uint256 = f;
    }
}
// ====
// EVMVersion: >=constantinople
// ----
// Warning 2264: (278-307): Experimental features are turned on. Do not use experimental features on live deployments.
// Info 4164: (309-342): Inferred type: word:(type, +)
// Info 4164: (344-564): Inferred type: void
// Info 4164: (375-562): Inferred type: (word, word) -> word
// Info 4164: (387-393): Inferred type: (word, word)
// Info 4164: (388-389): Inferred type: word
// Info 4164: (391-392): Inferred type: word
// Info 4164: (397-404): Inferred type: word
// Info 4164: (419-420): Inferred type: word
// Info 4164: (423-437): Inferred type: word
// Info 4164: (423-434): Inferred type: word -> word
// Info 4164: (423-430): Inferred type: word
// Info 4164: (435-436): Inferred type: word
// Info 4164: (451-452): Inferred type: word
// Info 4164: (455-469): Inferred type: word
// Info 4164: (455-466): Inferred type: word -> word
// Info 4164: (455-462): Inferred type: word
// Info 4164: (467-468): Inferred type: word
// Info 4164: (541-555): Inferred type: word
// Info 4164: (541-552): Inferred type: word -> word
// Info 4164: (541-548): Inferred type: word
// Info 4164: (553-554): Inferred type: word
// Info 4164: (566-627): Inferred type: word -> word
// Info 4164: (587-598): Inferred type: word
// Info 4164: (588-597): Inferred type: word
// Info 4164: (590-597): Inferred type: word
// Info 4164: (602-609): Inferred type: word
// Info 4164: (623-624): Inferred type: word
// Info 4164: (629-685): Inferred type: word -> word
// Info 4164: (639-650): Inferred type: word
// Info 4164: (640-649): Inferred type: word
// Info 4164: (642-649): Inferred type: word
// Info 4164: (654-661): Inferred type: word
// Info 4164: (675-682): Inferred type: word
// Info 4164: (675-676): Inferred type: word -> word
// Info 4164: (677-681): Inferred type: word
// Info 4164: (677-678): Inferred type: word -> word
// Info 4164: (679-680): Inferred type: word
// Info 4164: (687-737): Inferred type: word -> word
// Info 4164: (697-708): Inferred type: word
// Info 4164: (698-707): Inferred type: word
// Info 4164: (700-707): Inferred type: word
// Info 4164: (712-719): Inferred type: word
// Info 4164: (733-734): Inferred type: word
// Info 4164: (739-789): Inferred type: word -> word
// Info 4164: (749-760): Inferred type: word
// Info 4164: (750-759): Inferred type: word
// Info 4164: (752-759): Inferred type: word
// Info 4164: (764-771): Inferred type: word
// Info 4164: (785-786): Inferred type: word
// Info 4164: (808-872): Inferred type: () -> ()
// Info 4164: (816-818): Inferred type: ()
// Info 4164: (842-861): Inferred type: word -> word
// Info 4164: (845-861): Inferred type: word -> word
// Info 4164: (845-852): Inferred type: word
// Info 4164: (854-861): Inferred type: word
// Info 4164: (864-865): Inferred type: word -> word
