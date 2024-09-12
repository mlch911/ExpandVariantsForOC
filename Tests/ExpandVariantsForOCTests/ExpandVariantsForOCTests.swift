import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroTesting

#if canImport(ExpandVariantsForOCPlugin)
@testable import ExpandVariantsForOCPlugin
@testable import ExpandVariantsForOC

final class ExpandVariantsForOCMacroTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
            record: true,
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

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(topic: MaxBBSTopicModel?) {
                toPostLink(topic: topic, option: nil, h_src: nil, source: .none)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption?) {
                toPostLink(topic: topic, option: option, h_src: nil, source: .none)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(topic: MaxBBSTopicModel?, h_src: String?) {
                toPostLink(topic: topic, option: nil, h_src: h_src, source: .none)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(topic: MaxBBSTopicModel?, source: PostLinkReportSourceType) {
                toPostLink(topic: topic, option: nil, h_src: nil, source: source)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , h_src: String?) {
                toPostLink(topic: topic, option: option, h_src: h_src, source: .none)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(topic: MaxBBSTopicModel?, option: PostLinkOption? , source: PostLinkReportSourceType) {
                toPostLink(topic: topic, option: option, h_src: nil, source: source)
            }

            @objc @available(swift, obsoleted: 1.0)
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

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(test topic: MaxBBSTopicModel?) {
                toPostLink(test: topic, nil, h_src: nil, source: .none)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(test topic: MaxBBSTopicModel?, _ option: PostLinkOption?) {
                toPostLink(test: topic, option, h_src: nil, source: .none)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(test topic: MaxBBSTopicModel?, h_src: String?) {
                toPostLink(test: topic, nil, h_src: h_src, source: .none)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(test topic: MaxBBSTopicModel?, source: PostLinkReportSourceType) {
                toPostLink(test: topic, nil, h_src: nil, source: source)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(test topic: MaxBBSTopicModel?, _ option: PostLinkOption? , h_src: String?) {
                toPostLink(test: topic, option, h_src: h_src, source: .none)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(test topic: MaxBBSTopicModel?, _ option: PostLinkOption? , source: PostLinkReportSourceType) {
                toPostLink(test: topic, option, h_src: nil, source: source)
            }

            @objc @available(swift, obsoleted: 1.0)
            func toPostLink(test topic: MaxBBSTopicModel?, h_src: String? , source: PostLinkReportSourceType) {
                toPostLink(test: topic, nil, h_src: h_src, source: source)
            }
            """
        }
    }
}
#endif
