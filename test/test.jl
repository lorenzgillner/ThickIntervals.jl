using ThickIntervalDefinition

# Erstelle zwei Thick Intervals
a = ThickInterval(1.0, 2.0, 0.5, 2.5)  # Inneres: [1,2], Äußeres: [0.5,2.5]
b = ThickInterval(2.0, 3.0, 1.5, 3.5)  # Inneres: [2,3], Äußeres: [1.5,3.5]

# Führe Berechnungen durch
c = a + b  # Addition
d = a * b  # Multiplikation
e = a / b # Division

# Analysiere die Ergebnisse
println(inner_width(c))  # Breite des inneren Intervalls
println(thickness(c))    # Dicke des Intervalls
println(inner_width(d))
println(thickness(d))
println(inner_width(e))
println(thickness(e))