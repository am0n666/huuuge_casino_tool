add_this='		<node name="userSpecific">
			<node name="collectibles">
				<node name="3">
					<node name="newItems">
						<node name="1">
							<key name="1" type="bool">true</key>
							<key name="9" type="bool">true</key>
						</node>
						<node name="2">
							<key name="11" type="bool">true</key>
							<key name="13" type="bool">true</key>
							<key name="15" type="bool">true</key>
							<key name="17" type="bool">true</key>
						</node>
						<node name="3">
							<key name="23" type="bool">true</key>
						</node>
						<node name="4">
							<key name="33" type="bool">true</key>
							<key name="35" type="bool">true</key>
						</node>
						<node name="5">
							<key name="42" type="bool">true</key>
							<key name="43" type="bool">true</key>
						</node>
					</node>
					<node name="newSets">
						<key name="1" type="bool">true</key>
						<key name="2" type="bool">true</key>
						<key name="3" type="bool">true</key>
						<key name="4" type="bool">true</key>
						<key name="5" type="bool">true</key>
					</node>
				</node>
				<node name="4">
					<node name="newItems">
						<node name="1">
							<key name="4" type="bool">true</key>
							<key name="9" type="bool">true</key>
						</node>
						<node name="13">
							<key name="122" type="bool">true</key>
						</node>
						<node name="16">
							<key name="155" type="bool">true</key>
						</node>
						<node name="3">
							<key name="22" type="bool">true</key>
						</node>
						<node name="5">
							<key name="42" type="bool">true</key>
							<key name="46" type="bool">true</key>
						</node>
						<node name="6">
							<key name="54" type="bool">true</key>
						</node>
						<node name="8">
							<key name="75" type="bool">true</key>
						</node>
						<node name="9">
							<key name="81" type="bool">true</key>
						</node>
					</node>
					<node name="newSets">
						<key name="1" type="bool">true</key>
						<key name="13" type="bool">true</key>
						<key name="16" type="bool">true</key>
						<key name="3" type="bool">true</key>
						<key name="5" type="bool">true</key>
						<key name="6" type="bool">true</key>
						<key name="8" type="bool">true</key>
						<key name="9" type="bool">true</key>
					</node>
				</node>
				<node name="newThemes">
					<key name="3" type="bool">true</key>
					<key name="4" type="bool">true</key>
				</node>
				<node name="tutorial">
					<node name="3">
					</node>
				</node>
			</node>
		</node>
		<node name="vault">
			<key name="info_popup_shown" type="bool">true</key>
			<key name="tutorial_shown" type="bool">true</key>
		</node>
		<node name="workout">
			<key name="static_tutorial_shown" type="bool">true</key>
			<key name="tutorial_shown" type="bool">true</key>
		</node>
	</node>
</registry>'

save_file="save1"
save_out="_save1"

lines_count=0

while read line; do
	let lines_count++
done < "$save_file"

#echo $lines_count


	find_str='<node name="userSpecific">'

	n=2
	cut=0
	while read line; do
		if [ "$line" == "$find_str" ]; then
#			echo "$n"
			cut=$(expr $n - 2)
#			let cut++
		fi
		let n++
	done < "$save_file"

cut_lines=$(expr $lines_count - $cut)

head -n -$cut_lines "$save_file" > "$save_out"

echo "$add_this" >> "$save_out"
