import "cico.raylib" for Vector2, Vector3, Vector4,Raylib,Rectangle,Camera2D,Color,Font 
import "./cnodeui" for NodeUI, ControlResult, MenuContent
import "./cnode" for Control,Node,NodeSocket,NodeLink,NodePreview

class SysNode {
    
    // styles
    static cnodeDefault { Color.new(15, 17, 20, 200) }
    static cpinNumber { Color.new(177, 177, 177, 255) }
    static cpinVector2 { Color.new(200, 100, 166, 255) }
    static cpinVector3 { Color.new(200, 188, 255, 255) }
    static cpinVector4 { Color.new(200, 255, 134, 255) }
    static cpinColor { Color.new(255, 255, 134, 255) }
    static cpinString { Color.new(111, 222, 121, 255) }
    static cpinObject { Color.new(100, 60, 40, 255) }

    // color preview
    static ColorNodePreview { NodePreview.new(Vector2.new(100, 100), null, Fn.new{|node, ui, bounds|
        var inputs = node.inputs 
        var color = null 
        if(node.name.contains("Seperate")) {
            color = inputs[0].defaultValue
        } else {
            color = Color.new(inputs[0].defaultValue, inputs[1].defaultValue, inputs[2].defaultValue, inputs[3].defaultValue)
        }
        Raylib.DrawRectangleRec(bounds, color)
        Raylib.DrawRectangleLinesEx(bounds, 2, Color.new(255, 255, 255, 60))
        return 0
    })}

    static MathNumberOptions {[
        "Add", "Substract", "Multiply", "Divide", "Min", "Max"
    ]}
    static MathNumberNodePreview { NodePreview.new(Vector2.new(100, 100), {"option": 0, "options": SysNode.MathNumberOptions}, Fn.new{|node, ui, bounds|
        var result = ui.ComboBox(Rectangle.new(bounds.x, bounds.y, bounds.width, 20), node.preview.data["options"], node.preview.data["option"], node.preview.data)
        if(result.code == 2) { node.preview.data["option"] = result.values[0] }
        return result.code 
    })}

    // node logics
    static DefaultNodeLogic { Fn.new{|node| node.outputs[0].defaultValue = node.inputs[0].defaultValue } }
    static Vector2NodeLogic { Fn.new{|node|node.outputs[0].defaultValue = Vector2.new(node.inputs[0].defaultValue, node.inputs[1].defaultValue) }}
    static Vector3NodeLogic { Fn.new{|node|node.outputs[0].defaultValue = Vector3.new(node.inputs[0].defaultValue, node.inputs[1].defaultValue, node.inputs[2].defaultValue) } }
    static Vector4NodeLogic { Fn.new{|node|node.outputs[0].defaultValue = Vector4.new(node.inputs[0].defaultValue, node.inputs[1].defaultValue, node.inputs[2].defaultValue, node.inputs[3].defaultValue) } }
    static ColorNodeLogic { Fn.new{|node|node.outputs[0].defaultValue = Color.new(node.inputs[0].defaultValue, node.inputs[1].defaultValue, node.inputs[2].defaultValue, node.inputs[3].defaultValue) } }
    
    static SeperateVector2NodeLogic { Fn.new{|node|
        node.outputs[0].defaultValue = node.inputs[0].defaultValue.x
        node.outputs[1].defaultValue = node.inputs[0].defaultValue.y
    }}
    static SeperateVector3NodeLogic { Fn.new{|node|
        node.outputs[0].defaultValue = node.inputs[0].defaultValue.x
        node.outputs[1].defaultValue = node.inputs[0].defaultValue.y 
        node.outputs[2].defaultValue = node.inputs[0].defaultValue.z 
    }}
    static SeperateVector4NodeLogic { Fn.new{|node|
        node.outputs[0].defaultValue = node.inputs[0].defaultValue.x
        node.outputs[1].defaultValue = node.inputs[0].defaultValue.y
        node.outputs[2].defaultValue = node.inputs[0].defaultValue.z 
        node.outputs[3].defaultValue = node.inputs[0].defaultValue.w
    }}
    static SeperateColorNodeLogic { Fn.new{|node|
        node.outputs[0].defaultValue = node.inputs[0].defaultValue.r
        node.outputs[1].defaultValue = node.inputs[0].defaultValue.g
        node.outputs[2].defaultValue = node.inputs[0].defaultValue.b
        node.outputs[3].defaultValue = node.inputs[0].defaultValue.a
    }}
    static MathNumberNodeLogic { Fn.new{|node|
        // "Add", "Substract", "Multiply", "Divide", "Min", "Max"
        if(node.preview.data["option"] == 0) {
            node.outputs[0].defaultValue = node.inputs[0].defaultValue + node.inputs[1].defaultValue
        } else if (node.preview.data["option"] == 1) {
            node.outputs[0].defaultValue = node.inputs[0].defaultValue - node.inputs[1].defaultValue
        } else if (node.preview.data["option"] == 2) {
            node.outputs[0].defaultValue = node.inputs[0].defaultValue * node.inputs[1].defaultValue
        } else if (node.preview.data["option"] == 3) {
            node.outputs[0].defaultValue = node.inputs[0].defaultValue / node.inputs[1].defaultValue
        } else if (node.preview.data["option"] == 4) {
            node.outputs[0].defaultValue = node.inputs[0].defaultValue.min(node.inputs[1].defaultValue)
        } else if (node.preview.data["option"] == 5) {
            node.outputs[0].defaultValue = node.inputs[0].defaultValue.max(node.inputs[1].defaultValue)
        }
    }}

    static InternalNodeFactories {
        return [
            // Input.Constant 
            { "category": "Input.Constant", "name": "Number", "type": "Object",
                "fn": Fn.new{|id, pos|
                    return Node.new( id,  "Number",  "Object", pos, "", cnodeDefault,
                        [ NodeSocket.new(0, id, "", "Number", 1, NodeSocket.DirNone, cpinNumber, 0) ],
                        [ NodeSocket.new(0, id, "Value", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0) ],
                        SysNode.DefaultNodeLogic
                    )
                }
            },
            { "category": "Input.Constant", "name": "String", "type": "Object",
                "fn": Fn.new{|id, pos|
                    var node = Node.new( id,  "String", "Object", pos, "", cnodeDefault,
                        [ NodeSocket.new(0, id, "", "String", 1, NodeSocket.DirNone, cpinString, "") ],
                        [ NodeSocket.new(0, id, "Path", "String", 1, NodeSocket.DirOutput, cpinString, "") ],
                        SysNode.DefaultNodeLogic
                    )
                    node.controlSize.x = 120
                    node.recaculatebounds_()
                    return node 
                }
            },
            { "category": "Input.Constant", "name": "Vector2", "type": "Object",
                "fn": Fn.new{|id, pos|
                    return Node.new( id, "Vector2", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirNone, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirNone, cpinNumber, 0)
                        ],
                        [ NodeSocket.new(0, id, "Value", "Vector2", 1, NodeSocket.DirOutput, cpinVector2, Vector2.new(0, 0)) ],
                        SysNode.Vector2NodeLogic
                    )
                }
            },
            { "category": "Input.Constant", "name": "Vector3", "type": "Object",
                "fn": Fn.new{|id, pos|
                    return Node.new( id, "Vector3", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirNone, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirNone, cpinNumber, 0),
                            NodeSocket.new(2, id, "Z", "Number", 1, NodeSocket.DirNone, cpinNumber, 0)
                        ],
                        [ NodeSocket.new(0, id, "Value", "Vector3", 1, NodeSocket.DirOutput, cpinVector3, Vector3.new(0, 0, 0)) ],
                        SysNode.Vector3NodeLogic
                    )
                }
            },
            { "category": "Input.Constant", "name": "Vector4", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    return Node.new(id, "Vector4", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirNone, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirNone, cpinNumber, 0),
                            NodeSocket.new(2, id, "Z", "Number", 1, NodeSocket.DirNone, cpinNumber, 0),
                            NodeSocket.new(3, id, "W", "Number", 1, NodeSocket.DirNone, cpinNumber, 0)
                        ],
                        [ NodeSocket.new(0, id, "Value", "Vector4", 1, NodeSocket.DirOutput, cpinVector4, Vector4.new()) ],
                        SysNode.Vector4NodeLogic
                    )
                }
            },
            { "category": "Input.Constant", "name": "Color", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    var node = Node.new(id, "Color", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "R", "Number", 1, NodeSocket.DirNone, cpinNumber, 255, 1000),
                            NodeSocket.new(1, id, "G", "Number", 1, NodeSocket.DirNone, cpinNumber, 255, 1000),
                            NodeSocket.new(2, id, "B", "Number", 1, NodeSocket.DirNone, cpinNumber, 255, 1000),
                            NodeSocket.new(3, id, "A", "Number", 1, NodeSocket.DirNone, cpinNumber, 255, 1000)
                        ],
                        [ NodeSocket.new(0, id, "Value", "Color", 1, NodeSocket.DirOutput, cpinColor, Color.new(255, 255, 255, 255)) ],
                        SysNode.ColorNodeLogic
                    )
                    node.controlSize.x = 35
                    node.preview = SysNode.ColorNodePreview
                    node.recaculatebounds_()
                    return node 
                }
            },
            //Utils.Vector2
            { "category": "Utils.Vector2", "name": "Seperate Vector2", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    return Node.new(id, "Seperate Vector2", "Object", pos, "", cnodeDefault,
                        [ NodeSocket.new(0, id, "Value", "Vector2", 1, NodeSocket.DirInput, cpinVector2, Vector2.new()) ],
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0)
                        ],
                        SysNode.SeperateVector2NodeLogic
                    )
                }
            },
            { "category": "Utils.Vector2", "name": "Combine Vector2", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    return Node.new(id, "Combine Vector2", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirInput, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirInput, cpinNumber, 0)
                        ],
                        [ NodeSocket.new(0, id, "Value", "Vector2", 1, NodeSocket.DirOutput, cpinVector2, Vector2.new()) ],
                        SysNode.Vector2NodeLogic
                    )
                }
            },
            { "category": "Utils.Vector3", "name": "Seperate Vector3", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    return Node.new(id, "Seperate Vector3", "Object", pos, "", cnodeDefault,
                        [ NodeSocket.new(0, id, "Value", "Vector3", 1, NodeSocket.DirInput, cpinVector3, Vector3.new()) ],
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(2, id, "Z", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0)
                        ],
                        SysNode.SeperateVector3NodeLogic
                    )
                }
            },
            { "category": "Utils.Vector3", "name": "Combine Vector3", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    return Node.new(id, "Combine Vector3", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirInput, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirInput, cpinNumber, 0),
                            NodeSocket.new(2, id, "Z", "Number", 1, NodeSocket.DirInput, cpinNumber, 0)
                        ],
                        [ NodeSocket.new(0, id, "Value", "Vector3", 1, NodeSocket.DirOutput, cpinVector3, Vector3.new()) ],
                        SysNode.Vector3NodeLogic
                    )
                    
                }
            },
            { "category": "Utils.Vector4", "name": "Seperate Vector4", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    return Node.new(id, "Seperate Vector4", "Object", pos, "", cnodeDefault,
                        [ NodeSocket.new(0, id, "Value", "Vector4", 1, NodeSocket.DirInput, cpinVector4, Vector4.new()) ],
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(2, id, "Z", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(3, id, "W", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0)
                        ],
                        SysNode.SeperateVector4NodeLogic
                    )
                }
            },
            { "category": "Utils.Vector4", "name": "Combine Vector4", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    return Node.new(id, "Combine Vector4", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "X", "Number", 1, NodeSocket.DirInput, cpinNumber, 0),
                            NodeSocket.new(1, id, "Y", "Number", 1, NodeSocket.DirInput, cpinNumber, 0),
                            NodeSocket.new(2, id, "Z", "Number", 1, NodeSocket.DirInput, cpinNumber, 0),
                            NodeSocket.new(3, id, "W", "Number", 1, NodeSocket.DirInput, cpinNumber, 0)
                        ],
                        [ NodeSocket.new(0, id, "Value", "Vector4", 1, NodeSocket.DirOutput, cpinVector4, Vector4.new()) ],
                        SysNode.Vector4NodeLogic
                    )
                }
            },
            { "category": "Utils.Color", "name": "Seperate Color", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    var node = Node.new(id, "Seperate Color", "Object", pos, "", cnodeDefault,
                        [ NodeSocket.new(0, id, "Value", "Color", 1, NodeSocket.DirInput, cpinColor, Color.new(255, 255, 255, 255)) ],
                        [ 
                            NodeSocket.new(0, id, "R", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(1, id, "G", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(2, id, "B", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0),
                            NodeSocket.new(3, id, "A", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0)
                        ],
                        SysNode.SeperateColorNodeLogic
                    )
                    node.controlSize.x = 35
                    node.preview = SysNode.ColorNodePreview
                    node.recaculatebounds_()
                    return node 
                }
            },
            { "category": "Utils.Color", "name": "Combine Color", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    var node = Node.new(id, "Combine Color", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "R", "Number", 1, NodeSocket.DirInput, cpinNumber, 255),
                            NodeSocket.new(1, id, "G", "Number", 1, NodeSocket.DirInput, cpinNumber, 255),
                            NodeSocket.new(2, id, "B", "Number", 1, NodeSocket.DirInput, cpinNumber, 255),
                            NodeSocket.new(3, id, "A", "Number", 1, NodeSocket.DirInput, cpinNumber, 255)
                        ],
                        [ NodeSocket.new(0, id, "Value", "Color", 1, NodeSocket.DirOutput, cpinColor, Color.new(255, 255, 255, 255)) ],
                        SysNode.ColorNodeLogic
                    )
                    node.controlSize.x = 35
                    node.preview = SysNode.ColorNodePreview
                    node.recaculatebounds_()
                    return node 
                }
            },
            // // Utils.Math 
            { "category": "Utils.Math", "name": "Number Math", "type": "Object", 
                "fn": Fn.new{|id, pos|
                    var node = Node.new(id, "Number Math", "Object", pos, "", cnodeDefault,
                        [ 
                            NodeSocket.new(0, id, "A", "Number", 1, NodeSocket.DirInput, cpinNumber, 0),
                            NodeSocket.new(1, id, "B", "Number", 1, NodeSocket.DirInput, cpinNumber, 0) 
                        ],
                        [  NodeSocket.new(1, id, "Result", "Number", 1, NodeSocket.DirOutput, cpinNumber, 0) ],
                        SysNode.MathNumberNodeLogic
                    )
                    node.preview = SysNode.MathNumberNodePreview
                    node.recaculatebounds_()
                    return node 
                }
            },
            // { "category": "Utils.Math", "name": "Vector2 Math", "type": "Object", 
            //     "fn": Fn.new{|id, pos|
            //         return Node.new(id, "Vector2 Math", "Object", pos, "", cnodeDefault,
            //             [ 
            //                 NodeSocket.new(0, id, "A", "Vector2", 1, NodeSocket.DirInput, cpinVector2, Vector2.new()),
            //                 NodeSocket.new(1, id, "B", "Vector2", 1, NodeSocket.DirInput, cpinVector2, Vector2.new()) 
            //             ],
            //             [ 
            //                 NodeSocket.new(1, id, "Result", "Vector2", 1, NodeSocket.DirOutput, cpinVector2, Vector2.new()) 
            //             ]
            //         )
            //     }
            // },
            // { "category": "Utils.Math", "name": "Vector3 Math", "type": "Object", 
            //     "fn": Fn.new{|id, pos|
            //         return Node.new(id, "Vector3 Math", "Object", pos, "", cnodeDefault,
            //             [ 
            //                 NodeSocket.new(0, id, "A", "Vector3", 1, NodeSocket.DirInput, cpinVector3, Vector3.new()),
            //                 NodeSocket.new(1, id, "B", "Vector3", 1, NodeSocket.DirInput, cpinVector3, Vector3.new()) 
            //             ],
            //             [ 
            //                 NodeSocket.new(1, id, "Result", "Vector3", 1, NodeSocket.DirOutput, cpinVector3, Vector3.new()) 
            //             ]
            //         )
            //     }
            // },
            // { "category": "Utils.Math", "name": "Vector4 Math", "type": "Object", 
            //     "fn": Fn.new{|id, pos|
            //         return Node.new(id, "Vector4 Math", "Object", pos, "", cnodeDefault,
            //             [ 
            //                 NodeSocket.new(0, id, "A", "Vector4", 1, NodeSocket.DirInput, cpinVector4, Vector4.new()),
            //                 NodeSocket.new(1, id, "B", "Vector4", 1, NodeSocket.DirInput, cpinVector4, Vector4.new()) 
            //             ],
            //             [ 
            //                 NodeSocket.new(1, id, "Result", "Vector4", 1, NodeSocket.DirOutput, cpinVector4, Vector4.new()) 
            //             ]
            //         )
            //     }
            // },
            // { "category": "Utils.Math", "name": "String Operator", "type": "Object", 
            //     "fn": Fn.new{|id, pos|
            //         return Node.new(id, "String Operator", "Object", pos, "", cnodeDefault,
            //             [ 
            //                 NodeSocket.new(0, id, "A", "String", 1, NodeSocket.DirInput, cpinString, ""),
            //                 NodeSocket.new(1, id, "B", "String", 1, NodeSocket.DirInput, cpinString, "") 
            //             ],
            //             [ 
            //                 NodeSocket.new(1, id, "Result", "String", 1, NodeSocket.DirOutput, cpinString, "") 
            //             ]
            //         )
            //     }
            // }
        ]
    }
}