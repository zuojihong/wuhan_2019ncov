using DataFrames, Statistics, CSV, Plots, Measures

patients_data = CSV.read("C:/Codespace/Julia/wuhan_2019ncov/2019-ncov-data-china.csv", missingstrings=["na"])

new_patients_wuhan = dropmissing(patients_data[:, [:date, :new_patients_wuhan]])
new_patients_hubei = dropmissing(patients_data[:, [:date, :new_patients_hubei]])
new_patients_china = dropmissing(patients_data[:, [:date, :new_patients_china]])

new_plot = plot(new_patients_wuhan[:, 1], new_patients_wuhan[:, 2], c=:blue, label="Wuhan patients")
plot!(new_plot, new_patients_hubei[:, 1], new_patients_hubei[:, 2], c=:green, label="Hubei patients")
plot!(new_plot, new_patients_china[:, 1], new_patients_china[:, 2], c=:red, ylabel="New patients", label="China patients", legend=:topleft)

new_joined_patients_hubei_on_wuhan = join(new_patients_hubei, new_patients_wuhan, on=:date)
new_joined_patients_hubei_on_wuhan[!, :new_patients_ex_wuhan] = map((ph, pw) -> ph-pw, new_joined_patients_hubei_on_wuhan[:, :new_patients_hubei], new_joined_patients_hubei_on_wuhan[:, :new_patients_wuhan])

new_joined_patients_china_on_wuhan = join(new_patients_china, new_patients_wuhan, on=:date)
new_joined_patients_china_on_wuhan[!, :new_patients_ex_wuhan] = map((pc, pw) -> pc-pw, new_joined_patients_china_on_wuhan[:, :new_patients_china], new_joined_patients_china_on_wuhan[:, :new_patients_wuhan])

new_joined_patients_china_on_hubei = join(new_patients_china, new_patients_hubei, on=:date)
new_joined_patients_china_on_hubei[!, :new_patients_ex_hubei] = map((pc, ph) -> pc-ph, new_joined_patients_china_on_hubei[:, :new_patients_china], new_joined_patients_china_on_hubei[:, :new_patients_hubei])

new_plot2 = plot(new_joined_patients_hubei_on_wuhan[:, 1], new_joined_patients_hubei_on_wuhan[:, :new_patients_wuhan], c=:blue, label="Wuhan patients")
plot!(new_plot2, new_joined_patients_hubei_on_wuhan[:, 1], new_joined_patients_hubei_on_wuhan[:, :new_patients_ex_wuhan], c=:green, label="Hubei ex Wuhan patients")
plot!(new_plot2, new_joined_patients_china_on_wuhan[:, 1], new_joined_patients_china_on_wuhan[:, :new_patients_ex_wuhan], c=:red, label="China ex Wuhan patients")
plot!(new_plot2, new_joined_patients_china_on_hubei[:, 1], new_joined_patients_china_on_hubei[:, :new_patients_ex_hubei], c=:purple, label="China ex Hubei patients", ylabel="New patients", legend=:topleft)

total_reported_patients_wuhan = dropmissing(patients_data[:, [:date, :total_patients_wuhan]])
total_reported_patients_hubei = dropmissing(patients_data[:, [:date, :total_patients_hubei]])
total_reported_patients_china = dropmissing(patients_data[:, [:date, :total_patients_china]])


total_plot = plot(total_reported_patients_wuhan[:, 1], total_reported_patients_wuhan[:, 2], c=:blue, label="Wuhan patients")
plot!(total_plot, total_reported_patients_hubei[:, 1], total_reported_patients_hubei[:, 2], c=:green, label="Hubei patients")
plot!(total_plot, total_reported_patients_china[:, 1], total_reported_patients_china[:, 2], ylabel="Total patients", c=:red, label="China patients", legend=:topleft)


joined_patients_hubei_on_wuhan = join(total_reported_patients_hubei, total_reported_patients_wuhan, on = :date)
joined_patients_hubei_on_wuhan[!, :total_patients_ex_wuhan] = map((ph, pw) -> ph-pw, joined_patients_hubei_on_wuhan[:, :total_patients_hubei], joined_patients_hubei_on_wuhan[:, :total_patients_wuhan])

joined_patients_china_on_wuhan = join(total_reported_patients_china, total_reported_patients_wuhan, on = :date)
joined_patients_china_on_wuhan[!, :total_patients_ex_wuhan] = map((pc, pw) -> pc-pw, joined_patients_china_on_wuhan[:, :total_patients_china], joined_patients_china_on_wuhan[:, :total_patients_wuhan])

joined_patients_china_on_hubei = join(total_reported_patients_china, total_reported_patients_hubei, on = :date)
joined_patients_china_on_hubei[!, :total_patients_ex_hubei] = map((pc, ph) -> pc-ph, joined_patients_china_on_hubei[:, :total_patients_china], joined_patients_china_on_hubei[:, :total_patients_hubei])

total_plot2 = plot(joined_patients_hubei_on_wuhan[:, 1], joined_patients_hubei_on_wuhan[:, :total_patients_wuhan], c=:blue, label="Wuhan patients")
plot!(total_plot2, joined_patients_hubei_on_wuhan[:, 1], joined_patients_hubei_on_wuhan[:, :total_patients_ex_wuhan], c=:green, label="Hubei ex Wuhan patients")
plot!(total_plot2, joined_patients_china_on_wuhan[:, 1], joined_patients_china_on_wuhan[:, :total_patients_ex_wuhan], c=:red, ylabel="Total patients", label="China ex Wuhan patients", legend=:topleft)
plot!(total_plot2, joined_patients_china_on_hubei[:, 1], joined_patients_china_on_hubei[:, :total_patients_ex_hubei], c=:purple, label="China ex Hubei patients")

plot(total_plot, total_plot2, new_plot, new_plot2, layout=(2, 2), legendfontsize=4, guidefontsize=6, tickfontsize=4, left_margin=0.05mm)
