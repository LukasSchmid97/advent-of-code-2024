def check_safe(text, tolerate_bad: 0)
  fail if tolerate_bad > 1
  safe_reports = 0
  text.split("\n").each do |report|
    report_vals = report.split.collect(&:to_i)
    comp = report_vals.first > report_vals.last ? :> : :<
    last_val = report_vals.first
    seen_bads = 0
    safe = report_vals[1..].all? do |val|
      boo = last_val.send(comp, val) && (val - last_val).abs <= 3 && (val - last_val).abs > 0
      if !boo && tolerate_bad > seen_bads
        seen_bads += 1
        next true
      end
      last_val = val
      boo
    end
    # hacky
    if !safe && tolerate_bad == 1
      last_val = report_vals[1]
      safe = report_vals[2..].all? do |val|
        boo = last_val.send(comp, val) && (val - last_val).abs <= 3 && (val - last_val).abs > 0
        if !boo && tolerate_bad > seen_bads
          seen_bads += 1
          next true
        end
        last_val = val
        boo
      end
    end
    # hacky
    puts [safe, report_vals].inspect
    safe_reports += 1 if safe
  end
  puts safe_reports
end

test_string = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

# check_safe(test_string)
check_safe(File.read('day2_input.txt'))
check_safe(File.read('day2_input.txt'), tolerate_bad: 1)
