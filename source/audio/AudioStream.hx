package audio;

import openfl.events.Event;
import openfl.net.URLRequest;
import flixel.FlxG;
import openfl.media.SoundTransform;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.utils.Assets;

// from fps plus
class AudioStream
{
    // TODO: Make an option to change the audio source and reset variables to avoid errors
    var sound:Sound;
    var channel:SoundChannel;
    public var playing:Bool = false;
    @:isVar public var time(get, /*set*/ never):Float = 0;
    public var volume(default, set):Float = FlxG.sound.volume;
    public var length:Float = 0;
    public var lastTime:Float = 0;
    public var initialized:Bool = false;
    public var onComplete:Event->Void;

    public function new()
    {
        sound = new Sound();

    }

    public function loadFromAssets(key:String)
    {
        if (sound != null)
        {
            sound = Assets.getMusic(key);
            length = sound.length;
            initialized = true;
        }
        else
            trace("sound is null");
    }

    public function loadFromFile(path:String)
    {
        if (sound != null)
        {
            sound = Sound.fromFile(path);
            length = sound.length;
            initialized = true;
        }
        else
            trace("sound is null");
    }

    public function loadFromHTTP(url:String)
    {
        if (sound != null)
        {
            sound = new Sound(new URLRequest(url));
            length = sound.length;
            initialized = true;
        }
        else
            trace("sound is null");
    }

    public function play()
    {
        if (channel == null)
        {
            channel = sound.play(lastTime);
            channel.soundTransform = new SoundTransform(volume);
            if (onComplete != null)
                channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
            playing = true;
        }
    }

    public function stop()
    {
        if (channel != null)
        {
            lastTime = channel.position;
            if (onComplete != null)
                channel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
            channel.stop();
            channel = null;
            playing = false;
        }
    }

    function set_volume(value:Float):Float
    {
        if (channel != null)
        {
            if (channel.soundTransform.volume == value)
                return value;
            channel.soundTransform = new SoundTransform(value);
            return value;
        }
        return 0;
    }

	function get_time():Float 
    {
        if (channel != null)
            return channel.position;
        else
            return lastTime;
	}

    /*
	function set_time(value:Float):Float 
    {
        if (channel != null)
        {
            stop();
            lastTime += value;
            if (lastTime > length)
                lastTime = 0;
            play();
            return lastTime;
        }
        return value;
	}*/
}