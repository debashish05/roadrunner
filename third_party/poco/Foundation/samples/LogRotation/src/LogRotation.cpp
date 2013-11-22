//
// LogRotation.cpp
//
// $Id: //poco/1.4/Foundation/samples/LogRotation/src/LogRotation.cpp#1 $
//
// This class demonstrates the Log rotation feature.
//
// Copyright (c) 2004-2006, Applied Informatics Software Engineering GmbH.
// and Contributors.
//
// Permission is hereby granted, free of charge, to any person or organization
// obtaining a copy of the software and accompanying documentation covered by
// this license (the "Software") to use, reproduce, display, distribute,
// execute, and transmit the Software, and to prepare derivative works of the
// Software, and to permit third-parties to whom the Software is furnished to
// do so, all subject to the following:
// 
// The copyright notices in the Software and this entire statement, including
// the above license grant, this restriction and the following disclaimer,
// must be included in all copies of the Software, in whole or in part, and
// all derivative works of the Software, unless such copies or derivative
// works are solely in the form of machine-executable object code generated by
// a source language processor.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
// SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
// FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//


#include "Poco/AutoPtr.h"
#include "Poco/ConsoleChannel.h"
#include "Poco/SplitterChannel.h"
#include "Poco/FileChannel.h"
#include "Poco/PatternFormatter.h"
#include "Poco/FormattingChannel.h"
#include "Poco/Message.h"
#include "Poco/Logger.h"
#include <iostream>
#include <sstream>


using Poco::AutoPtr;
using Poco::Channel;
using Poco::ConsoleChannel;
using Poco::SplitterChannel;
using Poco::FileChannel;
using Poco::FormattingChannel;
using Poco::Formatter;
using Poco::PatternFormatter;
using Poco::Logger;
using Poco::Message;


int main (int, char**)
{
	AutoPtr<SplitterChannel> splitterChannel(new SplitterChannel());

	AutoPtr<Channel> consoleChannel(new ConsoleChannel());
	AutoPtr<Channel> fileChannel(new FileChannel("test.log"));
	AutoPtr<FileChannel> rotatedFileChannel(new FileChannel("rotated.log"));

	rotatedFileChannel->setProperty("rotation", "100");
	rotatedFileChannel->setProperty("archive", "timestamp");

	splitterChannel->addChannel(consoleChannel);
	splitterChannel->addChannel(fileChannel);
	splitterChannel->addChannel(rotatedFileChannel);


	AutoPtr<Formatter> formatter(new PatternFormatter("%h-%M-%S.%i: %t"));
	AutoPtr<Channel> formattingChannel(new FormattingChannel(formatter, splitterChannel));

	Logger& logger = Logger::create("TestLog", formattingChannel, Message::PRIO_TRACE);

	for (int i = 0; i < 10; ++i)
	{
		std::ostringstream oss;
		oss << "Value of i: " << i;
		logger.fatal(oss.str());
	}

	return 0;
}
