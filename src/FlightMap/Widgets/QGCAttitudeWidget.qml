/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/**
 * @file
 *   @brief QGC Attitude Instrument
 *   @author Gus Grubba <gus@auterion.com>
 */

import QtQuick              2.3
import QtGraphicalEffects   1.0

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0
import QGroundControl.Vehicle   1.0

Item {
    id: root

    property bool showPitch:    true
    property var  vehicle:      null
    property real size
    property bool showHeading:  true

    property real _rollAngle:   vehicle ? vehicle.roll.rawValue  : 0
    property real _pitchAngle:  vehicle ? vehicle.pitch.rawValue : 0

    property real _fontSize:        ScreenTools.defaultFontPointSize
    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    width:  size
    height: size*1.2

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    Item {
        id:             instrument
        anchors.fill:   parent
        visible:        false

        //----------------------------------------------------
        //-- Artificial Horizon
        QGCArtificialHorizon {
            rollAngle:          _rollAngle
            pitchAngle:         _pitchAngle
            anchors.fill:       parent
        }
        //----------------------------------------------------
        //-- Pointer
        Image {
            id:                 pointer
            source:             "/qmlimages/attitudePointer.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
        }
        //----------------------------------------------------
        //-- Instrument Dial
        Image {
            id:                 instrumentDial
            source:             "/qmlimages/attitudeDial.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
            transform: Rotation {
                origin.x:       root.width  / 2
                origin.y:       root.height / 2
                angle:          -_rollAngle
            }
        }
        //----------------------------------------------------
        //-- Pitch
        QGCPitchIndicator {
            id:                 pitchWidget
            visible:            root.showPitch
            size:               root.size * 0.6
            anchors.verticalCenter: parent.verticalCenter
            pitchAngle:         _pitchAngle
            rollAngle:          _rollAngle
            color:              Qt.rgba(0,0,0,0)
        }
        //----------------------------------------------------
        //-- Cross Hair
        Image {
            id:                 crossHair
            anchors.centerIn:   parent
            source:             "/qmlimages/crossHair.svg"
            mipmap:             true
            width:              size * 0.45
            sourceSize.width:   width
            fillMode:           Image.PreserveAspectFit
        }
    }

    Rectangle {
        id:             mask
        anchors.fill:   instrument
        radius:         width*0.05
        color:          "black"
        visible:        false
    }

    OpacityMask {
        anchors.fill: instrument
        source: instrument
        maskSource: mask
    }

    //    Rectangle {
    //        id:             borderRect
    //        anchors.fill:   parent
    //        radius:         width / 2
    //        color:          Qt.rgba(0,0,0,0)
    //        border.color:   qgcPal.text
    //        border.width:   0
    //    }
    Rectangle{

        id:             pfdBottom
        anchors.bottomMargin:       Math.round(ScreenTools.defaultFontPixelHeight * .75)
        anchors.bottom:             parent.bottom
        anchors.horizontalCenter:   parent.horizontalCenter
        color:                      Qt.rgba(0.075,0.075,0.075,0.8)//"#222222"
        width:                      size - anchors.bottomMargin*2
        height:                     width*0.1
        radius:                     height*0.5


        QGCLabel {
            anchors.centerIn:       parent
            text:                       "HDG "+_headingString3
            color:                      "white"
            visible:                    showHeading
            font.pointSize:             _fontSize*1.25
            font.bold:                  true

            property string _headingString: vehicle ? vehicle.heading.rawValue.toFixed(0) : "0"
            property string _headingString2: _headingString.length === 1 ? "0" + _headingString : _headingString
            property string _headingString3: _headingString2.length === 2 ? "0" + _headingString2 : _headingString2


            //groundSpeed,airSpeed,throttlePct, climbRate, airSpeedSetpoint, distanceToHome

        }
        QGCLabel {
            anchors.left:       parent.left
            anchors.verticalCenter:     parent.verticalCenter
            anchors.leftMargin:         Math.round(ScreenTools.defaultFontPixelHeight*1.25)

            text:                       "THR "+_thrString2
            color:                      "white"
            visible:                    showHeading
            font.pointSize:             _fontSize*1.25
            font.bold:                  true

            property string _thrString: vehicle ? vehicle.throttlePct.rawValue.toFixed(0): "0"
            property string _thrString2: _thrString  ? _thrString +"%": _thrString


            //groundSpeed,airSpeed,throttlePct, climbRate, airSpeedSetpoint, distanceToHome

        }
        QGCLabel {
            anchors.right:       parent.right
            anchors.verticalCenter:     parent.verticalCenter
            anchors.rightMargin:         Math.round(ScreenTools.defaultFontPixelHeight*1.25)

            text:                       "HOME "+_distHomeString2
            color:                      "white"
            visible:                    showHeading
            font.pointSize:             _fontSize*1.25
            font.bold:                  true

            property string _distHomeString: vehicle ? vehicle.distanceToHome.rawValue.toFixed(0): "0"
            property string _distHomeString2: _distHomeString  ? _distHomeString +"m": _distHomeString

            //groundSpeed,airSpeed,throttlePct, climbRate, airSpeedSetpoint, distanceToHome

        }
    }

    Rectangle{

        id:             pfdTop
        anchors.topMargin:       Math.round(ScreenTools.defaultFontPixelHeight * .75)
        anchors.top:             parent.top
        anchors.horizontalCenter:   parent.horizontalCenter
        color:                      Qt.rgba(0.075,0.075,0.075,0.8)//"#222222"
        width:                      size -  anchors.topMargin*2
        height:                     width*0.1
        radius:                     height*0.5

        QGCLabel {
            anchors.left:           parent.left
            anchors.verticalCenter:     parent.verticalCenter
            anchors.leftMargin:         Math.round(ScreenTools.defaultFontPixelHeight*1.25)
            text:                       _modeString2
            color:                      "white"
            visible:                    true
            font.pointSize:             _fontSize*1.25
            font.bold:                  true

            property string _modeString: vehicle ? vehicle.flightMode: "Flight Mode"
            property string _modeString2: _modeString  ? _modeString : _modeString

            //groundSpeed,airSpeed,throttlePct, climbRate, airSpeedSetpoint, distanceToHome

        }
//        QGCLabel {
//            anchors.centerIn:           parent
//            text:                      vehicle.flying// _armString3
//            color:                      "white"
//            visible:                    true
//            font.pointSize:             _fontSize*1.25
//            font.bold:                  true

//            property var _tempGroup: globals.activeVehicle && globals.activeVehicle.temperature.count ? globals.activeVehicle.batteries.get(0) : undefined
//            property var _batteryValue: _batteryGroup ? _batteryGroup.percentRemaining.value : 0
//            property var _batteryVoltage: _batteryGroup ? _batteryGroup.voltage.value : 0

//        }


        QGCLabel {
            anchors.right:       parent.right
            anchors.verticalCenter:     parent.verticalCenter
            anchors.rightMargin:         Math.round(ScreenTools.defaultFontPixelHeight*1)
            text:                       _batteryVoltage2.toFixed(2) +"V "+_batteryCurrent2.toFixed(1)+"A " + _batteryPerc2+"%"
            color:                      "white"
            visible:                    true
            font.pointSize:             _fontSize*1.25
            font.bold:                  true

            property var _batteryGroup: globals.activeVehicle && globals.activeVehicle.batteries.count ? globals.activeVehicle.batteries.get(0) :undefined
            property var _batteryPerc: _batteryGroup ? _batteryGroup.percentRemaining.value : "0"
            property var _batteryPerc2: _batteryPerc ? _batteryPerc:_batteryPerc
            property var _batteryVoltage: _batteryGroup ? _batteryGroup.voltage.value : "0"
            property var _batteryVoltage2: _batteryVoltage ? _batteryVoltage: _batteryVoltage
            property var _batteryCurrent: _batteryGroup ? _batteryGroup.current.value : "0"
            property var _batteryCurrent2: _batteryCurrent ? _batteryCurrent: _batteryCurrent


//            property string _gsString: vehicle ? vehicle.groundSpeed.rawValue.toFixed(1) : "0"
//            property string _gsString2: _gsString  ? _gsString+"m/s" : _gsString

        }
    }

    Rectangle{
        id:             pfdLeft
        anchors.leftMargin:       Math.round(ScreenTools.defaultFontPixelHeight * .2)
        anchors.left:             parent.left
        anchors.verticalCenter:   parent.verticalCenter
        color:                     Qt.rgba(0.075,0.075,0.075,0.8)//"#222222"
        width:                      size*0.25
        height:                     size*0.15
        radius:                     height*0.2

        QGCLabel {
            anchors.centerIn:           parent


            text:                       "GS "+_gsString2+"\nAS "+_asString2
            color:                      "white"
            visible:                    showHeading
            font.pointSize:             _fontSize*1
            font.bold:                  true

            property string _gsString: vehicle ? vehicle.groundSpeed.rawValue.toFixed(1) : "0"
            property string _gsString2: _gsString  ? _gsString+"m/s" : _gsString

            property string _asString: vehicle ? vehicle.airSpeed.rawValue.toFixed(1) : "0"
            property string _asString2: _asString  ? _asString+"m/s" : _asString


            //groundSpeed,airSpeed,throttlePct, climbRate, airSpeedSetpoint, distanceToHome, messagesReceived, armed


        }


    }

    Rectangle{
        id:             pfdRight
        anchors.rightMargin:       Math.round(ScreenTools.defaultFontPixelHeight * .2)
        anchors.right:             parent.right
        anchors.verticalCenter:   parent.verticalCenter
        color:                      Qt.rgba(0.075,0.075,0.075,0.8)//"#222222"
        width:                      size*0.25
        height:                     size*0.15
        radius:                     height*0.2

        QGCLabel {

            anchors.centerIn:           parent


            text:                       "ALT "+_altString2+"\n V/S "+_clmbString2
            color:                      "white"
            visible:                    showHeading
            font.pointSize:             _fontSize*1
            font.bold:                  true

            property string _altString: vehicle ? vehicle.altitudeRelative.rawValue.toFixed(1) : "0"
            property string _altString2: _altString ? _altString+"m" : _altString


            property string _clmbString: vehicle ? vehicle.climbRate.rawValue.toFixed(1) : "0"
            property string _clmbString2: _clmbString  ? _clmbString+"m" : _clmbString

            //groundSpeed,airSpeed,throttlePct, climbRate, airSpeedSetpoint, distanceToHome, messagesReceived, armed

        }
    }
    QGCLabel {
        anchors.bottom:             pfdBottom.top
        anchors.horizontalCenter:     parent.horizontalCenter
        anchors.bottomMargin:         Math.round(ScreenTools.defaultFontPixelHeight)
        text:                       _armString3
        color:                      "white"
        visible:                    true
        font.pointSize:             _fontSize*2
        font.bold:                  true

        property string _armString: vehicle ? vehicle.armed: "State"
        property string _armString2: _armString==="false" ? "DISARMED" : _armString
        property string _armString3: _armString2==="true" ? "ARMED" : _armString2

    }
}
