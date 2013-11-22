//
// TCPServer.cpp
//
// $Id: //poco/1.4/Net/src/TCPServer.cpp#1 $
//
// Library: Net
// Package: TCPServer
// Module:  TCPServer
//
// Copyright (c) 2005-2006, Applied Informatics Software Engineering GmbH.
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


#include "Poco/Net/TCPServer.h"
#include "Poco/Net/TCPServerDispatcher.h"
#include "Poco/Net/TCPServerConnection.h"
#include "Poco/Net/TCPServerConnectionFactory.h"
#include "Poco/Timespan.h"
#include "Poco/Exception.h"
#include "Poco/ErrorHandler.h"


using Poco::ErrorHandler;


namespace Poco {
namespace Net {


TCPServer::TCPServer(TCPServerConnectionFactory::Ptr pFactory, const ServerSocket& socket, TCPServerParams::Ptr pParams):
	_socket(socket),
	_pDispatcher(new TCPServerDispatcher(pFactory, Poco::ThreadPool::defaultPool(), pParams)),
	_thread(threadName(socket)),
	_stopped(true)
{
}


TCPServer::TCPServer(TCPServerConnectionFactory::Ptr pFactory, Poco::ThreadPool& threadPool, const ServerSocket& socket, TCPServerParams::Ptr pParams):
	_socket(socket),
	_pDispatcher(new TCPServerDispatcher(pFactory, threadPool, pParams)),
	_thread(threadName(socket)),
	_stopped(true)
{
}


TCPServer::~TCPServer()
{
	stop();
	_pDispatcher->release();
}


const TCPServerParams& TCPServer::params() const
{
	return _pDispatcher->params();
}


void TCPServer::start()
{
	poco_assert (_stopped);

	_stopped = false;
	_thread.start(*this);
}

	
void TCPServer::stop()
{
	if (!_stopped)
	{
		_stopped = true;
		_thread.join();
		_pDispatcher->stop();
	}
}


void TCPServer::run()
{
	while (!_stopped)
	{
		Poco::Timespan timeout(250000);
		if (_socket.poll(timeout, Socket::SELECT_READ))
		{
			try
			{
				StreamSocket ss = _socket.acceptConnection();
				// enabe nodelay per default: OSX really needs that
				ss.setNoDelay(true);
				_pDispatcher->enqueue(ss);
			}
			catch (Poco::Exception& exc)
			{
				ErrorHandler::handle(exc);
			}
			catch (std::exception& exc)
			{
				ErrorHandler::handle(exc);
			}
			catch (...)
			{
				ErrorHandler::handle();
			}
		}
	}
}


int TCPServer::currentThreads() const
{
	return _pDispatcher->currentThreads();
}

	
int TCPServer::totalConnections() const
{
	return _pDispatcher->totalConnections();
}


int TCPServer::currentConnections() const
{
	return _pDispatcher->currentConnections();
}


int TCPServer::maxConcurrentConnections() const
{
	return _pDispatcher->maxConcurrentConnections();
}

	
int TCPServer::queuedConnections() const
{
	return _pDispatcher->queuedConnections();
}


int TCPServer::refusedConnections() const
{
	return _pDispatcher->refusedConnections();
}


std::string TCPServer::threadName(const ServerSocket& socket)
{
	std::string name("TCPServer: ");
	name.append(socket.address().toString());
	return name;
}


} } // namespace Poco::Net
