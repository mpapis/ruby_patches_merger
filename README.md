# Ruby Patches Manager

Help to manage ruby patches.

## Installation

    gem install ruby_patches_merger

## Usage

So far only downloading patches for revisions is implemented:

    ruby_patches_merger r39171,r39296,r39333,r39334

Will download patches for those revisions to `patches/`, thanks to https://bugs.ruby-lang.org/issues/7959#note-16

## Testing

It's coming, for now run `bin/ruby_patches_merger ...`
