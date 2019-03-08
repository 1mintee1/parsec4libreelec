# parsec4libreelec
currently partially working with docker run --privileged -it --rm ...

this is not the ideal way to run this, but it didn't seem to be working 
with only --device=/dev/vchiq.  So there must be something else 
missing.

Also, ALSA seems to be the default audio controller, rebuilding with 
pulseaudio next.

