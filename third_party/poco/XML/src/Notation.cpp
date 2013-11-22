//
// Notation.cpp
//
// $Id: //poco/1.4/XML/src/Notation.cpp#1 $
//
// Library: XML
// Package: DOM
// Module:  DOM
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


#include "Poco/DOM/Notation.h"


namespace Poco {
namespace XML {


Notation::Notation(Document* pOwnerDocument, const XMLString& name, const XMLString& publicId, const XMLString& systemId): 
	AbstractNode(pOwnerDocument),
	_name(name),
	_publicId(publicId),
	_systemId(systemId)
{
}


Notation::Notation(Document* pOwnerDocument, const Notation& notation): 
	AbstractNode(pOwnerDocument, notation),
	_name(notation._name),
	_publicId(notation._publicId),
	_systemId(notation._systemId)
{
}


Notation::~Notation()
{
}


const XMLString& Notation::nodeName() const
{
	return _name;
}


unsigned short Notation::nodeType() const
{
	return Node::NOTATION_NODE;
}


Node* Notation::copyNode(bool deep, Document* pOwnerDocument) const
{
	return new Notation(pOwnerDocument, *this);
}


} } // namespace Poco::XML
