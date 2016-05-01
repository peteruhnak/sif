baseline
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec package: 'SIF-Support'.
			spec package: 'SIF-Pharo' with: [ spec requires: #('SIF-Support') ].
			spec group: 'default' with: #('SIF-Pharo') ]