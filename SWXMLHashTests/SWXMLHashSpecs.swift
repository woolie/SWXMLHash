//
//  SWXMLHashTests.swift
//
//  Copyright (c) 2014 David Mohundro
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import SWXMLHash
import Quick
import Nimble

class SWXMLHashTests: QuickSpec {
    override func spec() {
        let xmlToParse = "<root><header><title>Test Title Header</title></header><catalog><book id=\"bk101\"><author>Gambardella, Matthew</author><title>XML Developer's Guide</title><genre>Computer</genre><price>44.95</price><publish_date>2000-10-01</publish_date><description>An in-depth look at creating applications with XML.</description></book><book id=\"bk102\"><author>Ralls, Kim</author><title>Midnight Rain</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-12-16</publish_date><description>A former architect battles corporate zombies, an evil sorceress, and her own childhood to become queen of the world.</description></book><book id=\"bk103\"><author>Corets, Eva</author><title>Maeve Ascendant</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-11-17</publish_date><description>After the collapse of a nanotechnology society in England, the young survivors lay the foundation for a new society.</description></book></catalog></root>"

        var xml = SWXMLElement(name: "to be set")
        let parser = SWXMLHash()

        beforeEach {
            xml = parser.parse((xmlToParse as NSString).dataUsingEncoding(NSUTF8StringEncoding))
        }

        describe("xml parsing") {
            it("should be able to parse individual elements") {
                expect(xml["root"]["header"]["title"].text).to.equal("Test Title Header")
            }

            it("should be able to parse element groups") {
                expect(xml["root"]["catalog"].group("book")[1]["author"].text).to.equal("Ralls, Kim")
            }

            it("should be able to iterate element groups") {
                expect(", ".join(xml["root"]["catalog"].group("book").map { elem in elem["genre"].text! })).to.equal("Computer, Fantasy, Fantasy")
            }
        }

        describe("xml parsing error scenarios") {
            it("should return an error element when keys don't match") {
                expect(xml["root"]["what"]["header"]["foo"].error).toNot.beNil()
            }

            it("should return an error element when indexers don't match") {
                expect(xml["what"].group("subelements")[5]["nomatch"].error).toNot.beNil()
            }
        }
    }
}