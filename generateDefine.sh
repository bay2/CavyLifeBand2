#!/bin/bash

swiftgen colors colors.txt > CavyLifeBand2/Common/ColorsDefine.swift
swiftgen images CavyLifeBand2/Assets.xcassets/ > CavyLifeBand2/Common/ImageDefine.swift
swiftgen strings CavyLifeBand2/Base.lproj/Localizable.strings > CavyLifeBand2/Common/LocalizableDefine.swift
swiftgen storyboards ./ > CavyLifeBand2/Common/StoryboardDefine.swift
