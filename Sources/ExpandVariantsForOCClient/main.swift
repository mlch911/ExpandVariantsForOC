import ExpandVariantsForOC

class Test {
	@ExpandVariantsForOC
	func toPostLink(test topic: Int?, _ option: Double? = nil, h_src: String? = nil, source: [String] = []) {
		print(topic ?? 0)
	}
}
