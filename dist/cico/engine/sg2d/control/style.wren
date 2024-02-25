import "cico.raylib" for Raylib,Color 

class ControlStyle {
    static [index] {
        if(!__map) {
            __map = {
                "default": {
                    "border": {"width": 1, "color": Color.new(188, 188, 188, 255)},
                    "fontColor": Color.new(88, 88, 88, 255),
                    "fontSize": 15
                },
                "window": {
                    "backgroundColor": Color.new(255, 255, 255, 255)
                },
                "button": {
                    "textColor": Color.new(22, 22, 22, 255),
                    "fontSize": 12,
                    "fontSpacing": 0,
                    "backgroundColor": Color.new(255, 255, 255, 255),
                    "radius": 4,
                    "border": {"width": 1, "color": Color.new(188, 188, 188, 255)},
                    "font": null
                },
                "checkbox": {
                    "fontSize": 15,
                    "fontColor": Color.new(88, 88, 88, 255),
                    "background": {
                        "color": Color.new(255, 255, 255, 255),
                        "border": {"width": 1, "color": Color.new(188, 188, 188, 255)},
                        "radius": 6
                    },
                    "indicator": {
                        "color": Color.new(66,200, 255, 255)
                    }
                },
                "combobox": {

                },
                "flickable": {

                },
                "label": {

                },
                "progressbar": {

                },
                "scrollbar": {

                },
                "slider": {
                    "background": {
                        "color": Color.new(188,188, 188, 255)
                    },
                    "slot": {
                        "color": Color.new(66,200, 255, 255)
                    },
                    "indicator": {
                        "color": Color.new(255, 255, 255, 255),
                        "border": {"width": 1, "color": Color.new(188, 188, 188, 255)}
                    }
                },
                "spinbox": {

                },
                "switch": {
                    "fontSize": 15,
                    "fontColor": Color.new(88, 88, 88, 255),
                    "background": {
                        "defaultColor": Color.new(255, 255, 255, 255),
                        "checkedColor": Color.new(66,200, 255, 255),
                        "border": {"width": 1, "color": Color.new(188, 188, 188, 255)}
                    },
                    "indicator": {
                        "color": Color.new(100, 100, 100, 255)
                    }
                },
                "tabview": {

                },
                "textfield": {
                    
                },
                "textinput": {

                },
                "menubar": {

                },
                "toolbar": {

                },
                "statusbar": {

                }
            }
        }
        return __map[index]
    }
}