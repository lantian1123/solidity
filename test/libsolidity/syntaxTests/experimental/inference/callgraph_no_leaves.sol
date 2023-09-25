// a<------b
// |       ^
// |       |
// |       |
// |       |
// |       |
// +------>c------->d-------->e------->f
//                            ^        |
//                            |        |
//                            |        |
//                            |        |
//                            |        v
//                            h<-------g

pragma experimental solidity;

function a()
{
    c();
}

function b()
{
    a();
}

function c()
{
    b();
    d();
}

function d()
{
    e();
}

function e()
{
    f();
}

function f()
{
    g();
}

function g()
{
    h();
}

function h()
{
    e();
}
// ----
// Warning 2264: (366-395): Experimental features are turned on. Do not use experimental features on live deployments.
// Info 4164: (397-422): Inferred type: () -> ()
// Info 4164: (407-409): Inferred type: ()
// Info 4164: (416-419): Inferred type: ()
// Info 4164: (416-417): Inferred type: () -> ()
// Info 4164: (424-449): Inferred type: () -> ()
// Info 4164: (434-436): Inferred type: ()
// Info 4164: (443-446): Inferred type: ()
// Info 4164: (443-444): Inferred type: () -> ()
// Info 4164: (451-485): Inferred type: () -> ()
// Info 4164: (461-463): Inferred type: ()
// Info 4164: (470-473): Inferred type: ()
// Info 4164: (470-471): Inferred type: () -> ()
// Info 4164: (479-482): Inferred type: ()
// Info 4164: (479-480): Inferred type: () -> ()
// Info 4164: (487-512): Inferred type: () -> ()
// Info 4164: (497-499): Inferred type: ()
// Info 4164: (506-509): Inferred type: ()
// Info 4164: (506-507): Inferred type: () -> ()
// Info 4164: (514-539): Inferred type: () -> ()
// Info 4164: (524-526): Inferred type: ()
// Info 4164: (533-536): Inferred type: ()
// Info 4164: (533-534): Inferred type: () -> ()
// Info 4164: (541-566): Inferred type: () -> ()
// Info 4164: (551-553): Inferred type: ()
// Info 4164: (560-563): Inferred type: ()
// Info 4164: (560-561): Inferred type: () -> ()
// Info 4164: (568-593): Inferred type: () -> ()
// Info 4164: (578-580): Inferred type: ()
// Info 4164: (587-590): Inferred type: ()
// Info 4164: (587-588): Inferred type: () -> ()
// Info 4164: (595-620): Inferred type: () -> ()
// Info 4164: (605-607): Inferred type: ()
// Info 4164: (614-617): Inferred type: ()
// Info 4164: (614-615): Inferred type: () -> ()
