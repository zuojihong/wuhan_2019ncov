using DataFrames, Plots, Measures, CSV

patients_data = CSV.read("C:/Codespace/Julia/wuhan_2019ncov/2019-ncov-data-china.csv", missingstrings=["na"])

total_patients_wuhan = dropmissing(patients_data[:, [:date, :total_patients_wuhan]])
total_patients_hubei = dropmissing(patients_data[:, [:date, :total_patients_hubei]])
total_patients_china = dropmissing(patients_data[:, [:date, :total_patients_china]])

total_death_wuhan = dropmissing(patients_data[:, [:date, :total_death_wuhan]])
total_death_hubei = dropmissing(patients_data[:, [:date, :total_death_hubei]])
total_death_china = dropmissing(patients_data[:, [:date, :total_death_china]])

fatality_wuhan = join(total_patients_wuhan, total_death_wuhan, on=:date)
fatality_wuhan[!, :fatality_wuhan] = map((pw, dw) -> dw/pw, fatality_wuhan[:, :total_patients_wuhan], fatality_wuhan[:, :total_death_wuhan])
fatality_hubei = join(total_patients_hubei, total_death_hubei, on=:date)
fatality_hubei[!, :fatality_hubei] = map((ph, dh) -> dh/ph, fatality_hubei[:, :total_patients_hubei], fatality_hubei[:, :total_death_hubei])
fatality_china = join(total_patients_china, total_death_china, on=:date)
fatality_china[!, :fatality_china] = map((pc, dc) -> dc/pc, fatality_china[:, :total_patients_china], fatality_china[:, :total_death_china])

fatality_plot = plot(fatality_wuhan[:, 1], fatality_wuhan[:, :fatality_wuhan], c=:blue, label="Wuhan fatality")
plot!(fatality_plot, fatality_hubei[:, 1], fatality_hubei[:, :fatality_hubei], c=:green, label="Hubei fatality")
plot!(fatality_plot, fatality_china[:, 1], fatality_china[:, :fatality_china], c=:red, label="China fatality", ylabel="Case fatality", legend=:topleft)


joined_fatality_hubei_on_wuhan = join(fatality_hubei, fatality_wuhan, on=:date)
joined_fatality_hubei_on_wuhan[!, :fatality_hubei_ex_wuhan] = map((ph, dh, pw, dw) -> (dh-dw)/(ph-pw), joined_fatality_hubei_on_wuhan[:, :total_patients_hubei], joined_fatality_hubei_on_wuhan[:, :total_death_hubei], joined_fatality_hubei_on_wuhan[:, :total_patients_wuhan], joined_fatality_hubei_on_wuhan[:, :total_death_wuhan])

joined_fatality_china_on_hubei = join(fatality_china, fatality_hubei, on=:date)
joined_fatality_china_on_hubei[!, :fatality_china_ex_hubei] = map((pc, dc, ph, dh) -> (dc-dh)/(pc-ph), joined_fatality_china_on_hubei[:, :total_patients_china], joined_fatality_china_on_hubei[:, :total_death_china], joined_fatality_china_on_hubei[:, :total_patients_hubei], joined_fatality_china_on_hubei[:, :total_death_hubei])

joined_fatality_china_on_wuhan = join(fatality_china, fatality_wuhan, on=:date)
joined_fatality_china_on_wuhan[!, :fatality_china_ex_wuhan] = map((pc, dc, pw, dw) -> (dc-dw)/(pc-pw), joined_fatality_china_on_wuhan[:, :total_patients_china], joined_fatality_china_on_wuhan[:, :total_death_china], joined_fatality_china_on_wuhan[:, :total_patients_wuhan], joined_fatality_china_on_wuhan[:, :total_death_wuhan])

fatality_plot2 = plot(joined_fatality_hubei_on_wuhan[:, 1], joined_fatality_hubei_on_wuhan[:, :fatality_wuhan], c=:blue, label="Wuhan fatality")
plot!(fatality_plot2, joined_fatality_hubei_on_wuhan[:, 1], joined_fatality_hubei_on_wuhan[:, :fatality_hubei_ex_wuhan], c=:green, label="Hubei ex Wuhan fatality")
plot!(fatality_plot2, joined_fatality_china_on_hubei[:, 1], joined_fatality_china_on_hubei[:, :fatality_china_ex_hubei], c=:purple, label="China ex Hubei fatality")
plot!(fatality_plot2, joined_fatality_china_on_wuhan[:, 1], joined_fatality_china_on_wuhan[:, :fatality_china_ex_wuhan], c=:red, label="China ex Wuhan fatality", ylabel="Case fatality", legend=:topleft)

plot(fatality_plot, fatality_plot2, layout=(1, 2), legendfontsize=4, guidefontsize=6, tickfontsize=4, left_margin=0.05mm)
