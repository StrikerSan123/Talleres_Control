

G1= tf(3,[1 0])
G2= tf(1,[1 0 1])

G= series(G1,G2)
H1=tf(3,1)

Gs= feedback(G,H1)


step(Gs)

polos=pole(Gs)
raices= roots(Gs.den{1})%saca los polos. La entrada es el denominador.
pzmap(Gs);

%para sacar polos
coefsden=Gs.den{1}