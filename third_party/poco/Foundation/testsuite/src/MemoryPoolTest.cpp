//
// MemoryPoolTest.cpp
//
// $Id: //poco/1.4/Foundation/testsuite/src/MemoryPoolTest.cpp#1 $
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


#include "MemoryPoolTest.h"
#include "CppUnit/TestCaller.h"
#include "CppUnit/TestSuite.h"
#include "Poco/MemoryPool.h"
#include <vector>


using Poco::MemoryPool;


MemoryPoolTest::MemoryPoolTest(const std::string& name): CppUnit::TestCase(name)
{
}


MemoryPoolTest::~MemoryPoolTest()
{
}


void MemoryPoolTest::testMemoryPool()
{
	MemoryPool pool1(100, 0, 10);
	
	assert (pool1.blockSize() == 100);
	assert (pool1.allocated() == 0);
	assert (pool1.available() == 0);
	
	std::vector<void*> ptrs;
	for (int i = 0; i < 10; ++i)
	{
		ptrs.push_back(pool1.get());
		assert (pool1.allocated() == i + 1);
		assert (pool1.available() == 0);
	}
	
	try
	{
		pool1.get();
		fail("pool exhausted - must throw exception");
	}
	catch (Poco::OutOfMemoryException&)
	{
	}
	
	int av = 0;
	for (std::vector<void*>::iterator it = ptrs.begin(); it != ptrs.end(); ++it)
	{
		pool1.release(*it);
		++av;
		assert (pool1.available() == av);
	}
	
	MemoryPool pool2(32, 5, 10);
	assert (pool2.available() == 5);
	assert (pool2.blockSize() == 32);
	assert (pool2.allocated() == 5);
}


void MemoryPoolTest::setUp()
{
}


void MemoryPoolTest::tearDown()
{
}


CppUnit::Test* MemoryPoolTest::suite()
{
	CppUnit::TestSuite* pSuite = new CppUnit::TestSuite("MemoryPoolTest");

	CppUnit_addTest(pSuite, MemoryPoolTest, testMemoryPool);

	return pSuite;
}
