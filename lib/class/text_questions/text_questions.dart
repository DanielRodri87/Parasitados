import 'package:flutter/material.dart';

class TextQuestions {

	static List<InlineSpan> parseItalics(String text, {TextStyle? style, TextStyle? italicStyle}) {
		final spans = <InlineSpan>[];
		final regex = RegExp(r'\*(.*?)\*');
		int start = 0;
		final normal = style ?? const TextStyle();
		final italic = italicStyle ?? const TextStyle(fontStyle: FontStyle.italic);
		for (final match in regex.allMatches(text)) {
			if (match.start > start) {
				spans.add(TextSpan(text: text.substring(start, match.start), style: normal));
			}
			spans.add(TextSpan(text: match.group(1), style: italic));
			start = match.end;
		}
		if (start < text.length) {
			spans.add(TextSpan(text: text.substring(start), style: normal));
		}
		return spans;
	}
	
}