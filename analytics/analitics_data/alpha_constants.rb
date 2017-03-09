module AlphaConstants
	REGEXES=[
		{"name": "Base64", "regex": /^(?:[A-Za-z0-9+]{4})*(?:[A-Za-z0-9+]{2}==|[A-Za-z0-9+]{3}=)?$/},
		{"name": "Hexidecimal", "regex": /^[0-9a-fA-F]+$/},
		{"name": "YouTube ID", "regex": /^[0-9a-zA-Z]{11}$/},
		{"name": "Bitly ID", "regex": /^[0-9a-zA-Z]{7}$/},
		{"name": "UTF-8", "regex": /^[0-9a-fA-F]{4}$/}
	]
end