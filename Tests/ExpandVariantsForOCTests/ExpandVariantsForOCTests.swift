import MacroTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(ExpandVariantsForOCPlugin)
@testable import ExpandVariantsForOC
@testable import ExpandVariantsForOCPlugin

final class ExpandVariantsForOCMacroTests: XCTestCase {
	override func invokeTest() {
		withMacroTesting(
			// swiftformat:disable:next all
//            record: true,
			macros: ["ExpandVariantsForOC": ExpandVariantsForOCMacro.self]
		) {
			super.invokeTest()
		}
	}

	func testMacro() throws {
		assertMacro {
			"""
			@ExpandVariantsForOC
			func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			    print(topic)
			}
			"""
		} expansion: {
			"""
			func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			    print(topic)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(topic: MaxBBSTopicModel?) {
			    toPostLink(topic: topic, option: nil, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption?) {
			    toPostLink(topic: topic, option: option, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(topic: MaxBBSTopicModel?, h_src: String?) {
			    toPostLink(topic: topic, option: nil, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(topic: MaxBBSTopicModel?, source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: nil, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , h_src: String?) {
			    toPostLink(topic: topic, option: option, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: option, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(topic: MaxBBSTopicModel?, h_src: String? , source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: nil, h_src: h_src, source: source)
			}
			"""
		}
	}

	func testMacroWith() throws {
		assertMacro {
			"""
			@ExpandVariantsForOC
			func toPostLink(test topic: MaxBBSTopicModel?, _ option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			    print(topic)
			}
			"""
		} expansion: {
			"""
			func toPostLink(test topic: MaxBBSTopicModel?, _ option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			    print(topic)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: MaxBBSTopicModel?) {
			    toPostLink(test: topic, nil, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: MaxBBSTopicModel?, _ option: PostLinkOption?) {
			    toPostLink(test: topic, option, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: MaxBBSTopicModel?, h_src: String?) {
			    toPostLink(test: topic, nil, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: MaxBBSTopicModel?, source: PostLinkReportSourceType) {
			    toPostLink(test: topic, nil, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: MaxBBSTopicModel?, _ option: PostLinkOption? , h_src: String?) {
			    toPostLink(test: topic, option, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: MaxBBSTopicModel?, _ option: PostLinkOption? , source: PostLinkReportSourceType) {
			    toPostLink(test: topic, option, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: MaxBBSTopicModel?, h_src: String? , source: PostLinkReportSourceType) {
			    toPostLink(test: topic, nil, h_src: h_src, source: source)
			}
			"""
		}
	}

	func testMacroWithReturnValue() throws {
		assertMacro {
			"""
			@ExpandVariantsForOC
			func toPostLink(test topic: Int?, _ option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) -> Int {
			    return topic ?? 0
			}
			"""
		} expansion: {
			"""
			func toPostLink(test topic: Int?, _ option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) -> Int {
			    return topic ?? 0
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: Int?) -> Int {
			    return toPostLink(test: topic, nil, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: Int?, _ option: PostLinkOption?) -> Int {
			    return toPostLink(test: topic, option, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: Int?, h_src: String?) -> Int {
			    return toPostLink(test: topic, nil, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: Int?, source: PostLinkReportSourceType) -> Int {
			    return toPostLink(test: topic, nil, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: Int?, _ option: PostLinkOption? , h_src: String?) -> Int {
			    return toPostLink(test: topic, option, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: Int?, _ option: PostLinkOption? , source: PostLinkReportSourceType) -> Int {
			    return toPostLink(test: topic, option, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			func toPostLink(test topic: Int?, h_src: String? , source: PostLinkReportSourceType) -> Int {
			    return toPostLink(test: topic, nil, h_src: h_src, source: source)
			}
			"""
		}
	}

	func testMacroWithOtherFuncAttribute() throws {
		assertMacro {
			"""
			@ExpandVariantsForOC
			@objc
			func toPostLink(test topic: Int?, _ option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) -> Int {
			    return topic ?? 0
			}
			"""
		} expansion: {
			"""
			@objc
			func toPostLink(test topic: Int?, _ option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) -> Int {
			    return topic ?? 0
			}

			@objc
			@available(swift, obsoleted: 1.0)
			@objc
			func toPostLink(test topic: Int?) -> Int {
			    return toPostLink(test: topic, nil, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			@objc
			func toPostLink(test topic: Int?, _ option: PostLinkOption?) -> Int {
			    return toPostLink(test: topic, option, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			@objc
			func toPostLink(test topic: Int?, h_src: String?) -> Int {
			    return toPostLink(test: topic, nil, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			@objc
			func toPostLink(test topic: Int?, source: PostLinkReportSourceType) -> Int {
			    return toPostLink(test: topic, nil, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			@objc
			func toPostLink(test topic: Int?, _ option: PostLinkOption? , h_src: String?) -> Int {
			    return toPostLink(test: topic, option, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			@objc
			func toPostLink(test topic: Int?, _ option: PostLinkOption? , source: PostLinkReportSourceType) -> Int {
			    return toPostLink(test: topic, option, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			@objc
			func toPostLink(test topic: Int?, h_src: String? , source: PostLinkReportSourceType) -> Int {
			    return toPostLink(test: topic, nil, h_src: h_src, source: source)
			}
			"""
		}
	}

	func testMacroWithNotFunction() throws {
		assertMacro {
			"""
			@ExpandVariantsForOC
			var test: Int = 0
			"""
		} diagnostics: {
			"""
			@ExpandVariantsForOC
			┬───────────────────
			╰─ 🛑 This macro can only be applied to functions.
			var test: Int = 0
			"""
		}
	}

	func testPublic() {
		assertMacro {
			"""
			@ExpandVariantsForOC
			public func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			    print(topic)
			}
			"""
		} expansion: {
			"""
			public func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			    print(topic)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public func toPostLink(topic: MaxBBSTopicModel?) {
			    toPostLink(topic: topic, option: nil, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption?) {
			    toPostLink(topic: topic, option: option, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public func toPostLink(topic: MaxBBSTopicModel?, h_src: String?) {
			    toPostLink(topic: topic, option: nil, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public func toPostLink(topic: MaxBBSTopicModel?, source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: nil, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , h_src: String?) {
			    toPostLink(topic: topic, option: option, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: option, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public func toPostLink(topic: MaxBBSTopicModel?, h_src: String? , source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: nil, h_src: h_src, source: source)
			}
			"""
		}
	}
	
	func testStatic() {
		assertMacro {
			"""
			@ExpandVariantsForOC
			public static func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			    print(topic)
			}
			"""
		} expansion: {
			"""
			public static func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			    print(topic)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public static func toPostLink(topic: MaxBBSTopicModel?) {
			    toPostLink(topic: topic, option: nil, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public static func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption?) {
			    toPostLink(topic: topic, option: option, h_src: nil, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public static func toPostLink(topic: MaxBBSTopicModel?, h_src: String?) {
			    toPostLink(topic: topic, option: nil, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public static func toPostLink(topic: MaxBBSTopicModel?, source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: nil, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public static func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , h_src: String?) {
			    toPostLink(topic: topic, option: option, h_src: h_src, source: .none)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public static func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: option, h_src: nil, source: source)
			}

			@objc
			@available(swift, obsoleted: 1.0)
			public static func toPostLink(topic: MaxBBSTopicModel?, h_src: String? , source: PostLinkReportSourceType) {
			    toPostLink(topic: topic, option: nil, h_src: h_src, source: source)
			}
			"""
		}
	}
	
	func testMacroInClass() throws {
		assertMacro {
			"""
			class TestClass {
			    @ExpandVariantsForOC
			    func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			        print(topic)
			    }
			}
			"""
		} expansion: {
			"""
			class TestClass {
			    func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? = nil, h_src: String? = nil, source: PostLinkReportSourceType = .none) {
			        print(topic)
			    }

			    @objc
			    @available(swift, obsoleted: 1.0)
			    func toPostLink(topic: MaxBBSTopicModel?) {
			        toPostLink(topic: topic, option: nil, h_src: nil, source: .none)
			    }

			    @objc
			    @available(swift, obsoleted: 1.0)
			    func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption?) {
			        toPostLink(topic: topic, option: option, h_src: nil, source: .none)
			    }

			    @objc
			    @available(swift, obsoleted: 1.0)
			    func toPostLink(topic: MaxBBSTopicModel?, h_src: String?) {
			        toPostLink(topic: topic, option: nil, h_src: h_src, source: .none)
			    }

			    @objc
			    @available(swift, obsoleted: 1.0)
			    func toPostLink(topic: MaxBBSTopicModel?, source: PostLinkReportSourceType) {
			        toPostLink(topic: topic, option: nil, h_src: nil, source: source)
			    }

			    @objc
			    @available(swift, obsoleted: 1.0)
			    func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , h_src: String?) {
			        toPostLink(topic: topic, option: option, h_src: h_src, source: .none)
			    }

			    @objc
			    @available(swift, obsoleted: 1.0)
			    func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , source: PostLinkReportSourceType) {
			        toPostLink(topic: topic, option: option, h_src: nil, source: source)
			    }

			    @objc
			    @available(swift, obsoleted: 1.0)
			    func toPostLink(topic: MaxBBSTopicModel?, h_src: String? , source: PostLinkReportSourceType) {
			        toPostLink(topic: topic, option: nil, h_src: h_src, source: source)
			    }
			}
			"""
		}
	}
		
}
#endif
