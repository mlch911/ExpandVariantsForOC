import ExpandVariantsForOC

public class Test {
	@ExpandVariantsForOC
	func toPostLink(test topic: Int?, _ option: Double? = nil, h_src: String? = nil, source: [String] = []) {
		print(topic ?? 0)
	}
}

public extension Test {
	@ExpandVariantsForOC
	func toLink(_ link: Int, recParams: [AnyHashable: Any]? = nil, fromIV: Double = .zero, fromImg: String? = nil, fromImgSize: [String] = []) {
		print(link)
	}
}
