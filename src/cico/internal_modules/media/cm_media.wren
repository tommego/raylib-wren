// enum MediaStatus
class MediaStatus {
    static Idle {0}
    static Loading {1}
    static Ready {2}
    static Playing {3}
    static Paused {4}
    static Seeking {5}
    static Finished {6}
    static Error {7}
}

// enum SoundEffect
class SoundEffect {
    static None {0}
    static FadeIn {1}
    static FadeOut {2}
    static FadeInOut {3}
}

// Media player 
foreign class MediaPlayer {
    construct new () {
    }

    // properties
    foreign status 
    foreign onStatusChanged
    foreign media
    foreign media = (source) 
    foreign position 
    foreign onPositionChanged
    foreign duration 
    foreign onDurationChanged
    foreign volume 
    foreign volume = (val)
    foreign replay 
    foreign replay = (val) 
    foreign fadeMode
    foreign fadeMode = (val)
    foreign clockSource
    foreign clockSource = (val)

    // methods
    foreign play()
    foreign pause()
    foreign resume()
    foreign stop()
    foreign seek(pos)

    // callback 
    foreign onMediaLoaded
    foreign onPlayStarted
    foreign onPlayGetEnd
    foreign onPlayStoped
    foreign onPlayPaused
    foreign onPlayResumed
    foreign onSeekSuccess
    foreign onSeekFailed
}

class SoundManager {
    // global properties
    foreign static musicVolume
    foreign static musicVolume = (val)
    foreign static soundVolume 
    foreign static soundVolume = (val)
    foreign static musicEffect 
    foreign static musicEffect = (val)
    
    // global methods
    foreign static playMusic(source)
    foreign static stopMusic(source)
    foreign static playSound(source)
    foreign static stopSound(source)
    foreign static stopAllSound()
    foreign static stopAll()
}