; switching displays via win+p is too cumbersome from the couch. sadly there's no way to switch between displays via keys without knowing whether the primary or secondary display is active.
; win+shift+p switches between two displays -> mapped to 'steam + >' on the controller
; TODO turn on TV and switch to input for PC or back to previous input
#+p::
    SysGet, MonitorWorkArea, MonitorWorkArea
    ; MsgBox, Right:`t%MonitorRight% (%MonitorWorkAreaRight% work right)
    If (MonitorWorkAreaRight == 3840) {
        Run, displayswitch /external
        ; switch TV to HDMI; works but if TV is already on PC-HDMI it will switch to RPi-HDMI :(
        ; Run, samsungctl --host 192.168.178.24 --method websocket KEY_HDMI
        ; this tries to always select the PC-HDMI source, but sometimes fails if the TV reacts too slow and sent buttons are lost
        ; Run C:\Users\Ralf\AppData\Local\Programs\Python\Python37-32\python.exe -m samsungctl --host 192.168.178.24 --method websocket KEY_SOURCE KEY_DOWN KEY_RIGHT KEY_RIGHT KEY_ENTER
    } Else
        Run, displayswitch /internal
Return

; turn off display, e.g. for downloads/uploads to run
#+d::
Sleep 1000
SendMessage, 0x112, 0xF170, 2,, Program Manager
return

; capslock to ctrl if pressed, or esc if released within 200ms
*CapsLock::
    Send {Blind}{Ctrl Down}
    cDown := A_TickCount
Return

*CapsLock up::
    If ((A_TickCount-cDown)<200) ; Modify press time as needed (milliseconds)
        Send {Blind}{Ctrl Up}{Esc}
    Else
        Send {Blind}{Ctrl Up}
Return

;Capslock:: Send {Esc}


; google: autohotkey deactivate fullscreen
; from: https://autohotkey.com/board/topic/70690-disable-ahk-in-all-full-screen-apps-and-games/
; disables everything below for fullscreen apps. what about games with 1080p or lower?
; -> maybe also try: https://autohotkey.com/board/topic/102555-disable-hotkeys-if-game-ran-borderless-or-fullscreen-mode/
#If ActiveWidth() != A_ScreenWidth and ActiveHeight() != A_ScreenHeight


; some bindings from awesome
; Win8 doesn't allow using AutoHotkey's AltTab...
; #j::Send !{ESC}
; #k::Send !+{ESC}
;#Tab::Send !{ESC}


;k::Send {WheelUp}
;j::Send {WheelDown}
;m::Send {PgUp}
;n::Send {PgDn}


; OS X like keys
; switch ctrl and cmd (done via SharpKeys instead)
; LWin::LCtrl
; LCtrl::LWin
; win+q = alt+f4
#q::Send {Alt Down}{F4}{Alt Up}
; win+tab = alt+tab
; LWin & Tab::AltTab
; ctrl+shift+[ and ] for tabs
;#k::Send {Ctrl Down}{Tab}{Ctrl Up}
;#j::Send {Ctrl Down}{Shift Down}{Tab}{Shift Up}{Ctrl Up}
;~LCtrl & [::Send {Ctrl Down}{Tab}{Ctrl Up}
; cmd (shift) brackets
^[::Send {Alt Down}{Left}{Alt Up}
^]::Send {Alt Down}{Right}{Alt Up}
^+[::Send {Ctrl Down}{Shift Down}{Tab}{Shift Up}{Ctrl Up}
^+]::Send {Ctrl Down}{Tab}{Ctrl Up}

; right mouse + ... (prevents right button drag & drop :/)
$RButton::Send {RButton}
RButton & WheelDown::Send {Ctrl Down}{Tab}{Ctrl Up}
RButton & WheelUp::Send {Ctrl Down}{Shift Down}{Tab}{Shift Up}{Ctrl Up}
RButton & LButton::Send {Ctrl Down}w{Ctrl Up}
;$LButton::Send {LButton}
;LButton & RButton::Send {Ctrl Down}t{Ctrl Up}

;$s:: send s
;$+s:: send S
;s & j::Send {Down}
;s & k::Send {Up}
;s & o::Send {Enter}

; win+esc for standby
#Esc::DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
;#Esc::Send {LWin Down}x{LWin Up}r{Down}{Enter}

ActiveWidth() {
  WinGetPos, , , w, , A
  return w
}

ActiveHeight() {
  WinGetPos, , , , h, A
  return h
}

^SPACE::  Winset, Alwaysontop, , A

; da ich Win-Key kaum nutze, w�re es vllt sinnvoll den auch auf Ctrl zu mappen, damit ich in zsh & vim nicht aus Versehen Win dr�cke, weil auf Mac da Ctrl ist
; LWin::LCtrl
; RCtrl::LWin ; nur weil ich in SharpKeys RWin auf RCtrl gemappt habe und Win ja irgendwo hin muss. Besser w�re aber doch links da ich oft Win dr�cke um Startmen� zu �ffnen wenn rechte Hand an Maus.