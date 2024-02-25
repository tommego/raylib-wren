import "cico/utils/serializer" for Serializer

var maps = {
    "animals": [
        {
            "name": "dog",
            "age": 12,
            "obj": null,
            "isDead": false
        },
        {
            "name": "cat",
            "age": 1,
            "obj": null,
            "isDead": false
        },
    ],
    "values": [
        1, 2, 3,4,5
    ]
}

var maps1 = [
    {
        "name": "dog",
        "age": 12,
        "obj": null,
        "isDead": false
    },
    {
        "name": "cat",
        "age": 1,
        "obj": null,
        "isDead": false
    }
]

var sret = Serializer.Stringify(maps1)

// System.print("result: %(maps1)")
System.print("result: %(sret)")