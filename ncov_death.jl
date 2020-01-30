using DataFrames, CSV, Plots, Measures

patients_data = CSV.read("C:/Codespace/Julia/wuhan_2019ncov/2019-ncov-data-china.csv", missingstrings=["na"])

# new death statistics

new_death_wuhan = dropmissing(patients_data[:, [:date, :new_death_wuhan]])
new_death_hubei = dropmissing(patients_data[:, [:date, :new_death_hubei]])
new_death_china = dropmissing(patients_data[:, [:date, :new_death_china]])

new_death_plot = plot(new_death_wuhan[:, 1], new_death_wuhan[:, 2], c=:blue, label="Wuhan death")
plot!(new_death_plot, new_death_hubei[:, 1], new_death_hubei[:, 2], c=:green, label="Hubei death")
plot!(new_death_plot, new_death_china[:, 1], new_death_china[:, 2], c=:red, label="China death", ylabel="New death", legend=:topleft)

new_joined_death_hubei_on_wuhan = join(new_death_hubei, new_death_wuhan, on=:date)
new_joined_death_hubei_on_wuhan[!, :new_death_hubei_ex_wuhan] = map((dh, dw) -> dh-dw, new_joined_death_hubei_on_wuhan[:, :new_death_hubei], new_joined_death_hubei_on_wuhan[:, :new_death_wuhan])

new_joined_death_china_on_hubei = join(new_death_china, new_death_hubei, on=:date)
new_joined_death_china_on_hubei[!, :new_death_china_ex_hubei] = map((dc, dh) -> dc-dh, new_joined_death_china_on_hubei[:, :new_death_china], new_joined_death_china_on_hubei[:, :new_death_hubei])

new_joined_death_china_on_wuhan = join(new_death_china, new_death_wuhan, on=:date)
new_joined_death_china_on_wuhan[!, :new_death_china_ex_wuhan] = map((dc, dw) -> dc-dw, new_joined_death_china_on_wuhan[:, :new_death_china], new_joined_death_china_on_wuhan[:, :new_death_wuhan])

new_death_plot2 = plot(new_joined_death_hubei_on_wuhan[:, 1], new_joined_death_hubei_on_wuhan[:, :new_death_wuhan], c=:blue, label="Wuhan death")
plot!(new_death_plot2, new_joined_death_hubei_on_wuhan[:, 1], new_joined_death_hubei_on_wuhan[:, :new_death_hubei_ex_wuhan], c=:green, label="Hubei ex Wuhan death")
plot!(new_death_plot2, new_joined_death_china_on_hubei[:, 1], new_joined_death_china_on_hubei[:, :new_death_china_ex_hubei], c=:purple, label="China ex Hubei death")
plot!(new_death_plot2, new_joined_death_china_on_wuhan[:, 1], new_joined_death_china_on_wuhan[:, :new_death_china_ex_wuhan], c=:red, label="China ex Wuhan death", ylabel="New death", legend=:topleft)

# total death statistics

total_death_wuhan = dropmissing(patients_data[:, [:date, :total_death_wuhan]])
total_death_hubei = dropmissing(patients_data[:, [:date, :total_death_hubei]])
total_death_china = dropmissing(patients_data[:, [:date, :total_death_china]])

total_death_plot = plot(total_death_wuhan[:, 1], total_death_wuhan[:, 2], c=:blue, label="Wuhan death")
plot!(total_death_plot, total_death_hubei[:, 1], total_death_hubei[:, 2], c=:green, label="Hubei death")
plot!(total_death_plot, total_death_china[:, 1], total_death_china[:, 2], c=:red, label="China death", ylabel="Total death", legend=:topleft)

total_joined_death_hubei_on_wuhan = join(total_death_hubei, total_death_wuhan, on=:date)
total_joined_death_hubei_on_wuhan[!, :total_death_hubei_ex_wuhan] = map((dh, dw) -> dh-dw, total_joined_death_hubei_on_wuhan[:, :total_death_hubei], total_joined_death_hubei_on_wuhan[:, :total_death_wuhan])

total_joined_death_china_on_hubei = join(total_death_china, total_death_hubei, on=:date)
total_joined_death_china_on_hubei[!, :total_death_china_ex_hubei] = map((dc, dh) -> dc-dh, total_joined_death_china_on_hubei[:, :total_death_china], total_joined_death_china_on_hubei[:, :total_death_hubei])

total_joined_death_china_on_wuhan = join(total_death_china, total_death_wuhan, on=:date)
total_joined_death_china_on_wuhan[!, :total_death_china_ex_wuhan] = map((dc, dw) -> dc-dw, total_joined_death_china_on_wuhan[:, :total_death_china], total_joined_death_china_on_wuhan[:, :total_death_wuhan])

total_death_plot2 = plot(total_joined_death_hubei_on_wuhan[:, 1], total_joined_death_hubei_on_wuhan[:, :total_death_wuhan], c=:blue, label="Wuhan death")
plot!(total_death_plot2, total_joined_death_hubei_on_wuhan[:, 1], total_joined_death_hubei_on_wuhan[:, :total_death_hubei_ex_wuhan], c=:green, label="Hubei ex Wuhan death")
plot!(total_death_plot2, total_joined_death_china_on_hubei[:, 1], total_joined_death_china_on_hubei[:, :total_death_china_ex_hubei], c=:purple, label="China ex Hubei death")
plot!(total_death_plot2, total_joined_death_china_on_wuhan[:, 1], total_joined_death_china_on_wuhan[:, :total_death_china_ex_wuhan], c=:red, label="China ex Wuhan death", ylabel="Total death", legend=:topleft)

plot(total_death_plot, total_death_plot2, new_death_plot, new_death_plot2, layout=(2, 2), legendfontsize=4, guidefontsize=6, tickfontsize=4, left_margin=0.05mm)
