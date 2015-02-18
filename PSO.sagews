︠37c162b1-4d9f-4383-8a3c-10f520b861b0︠
def randomBound(lo, hi):
    return random()*(hi-lo)+lo

def generateParticles(n, xranges):
    S = []
    for i in xrange(n):
        p = []
        for (lo, hi) in xranges:
            p.append( randomBound(lo, hi) )
        S.append(vector(p))
    return S

def clamp(lo, x, hi):
    return max(min(x, hi), lo)

particlePaths = []
def addParticlePath(f, positions):
    pts = [point( list(pos) + [f(*pos)], size=100, color=rainbow(len(positions))[i]) for i, pos in enumerate(positions)]
    particlePaths.append( sum(pts) + plot(f) )

# Returns a set of particle animations that demonstrates PSO
# f = function to evaluate
# T = max number of iterations
# key = optimizer
# criterion = exit criteria wrt best delta
# xranges = set of bounds defining the space
def pso(f, omega, phi_p, phi_g, *xranges, **params):
    global particlePaths
    particlePaths = []

    n=10 if 'num_particles' not in params else params['num_particles']
    T=10000 if 'limit_iterations' not in params else params['limit_iterations']
    epsilon=0. if 'epsilon' not in params else params['epsilon']
    keyframes=10 if 'keyframes' not in params else params['keyframes']

    # Generated particles are uniform-randomly distributed about space
    position = generateParticles(n, xranges)
    particleBestPosition = position[:]
    swarmBestPosition = min(position, key=lambda x: f(*x))
    prevBestValue = f(*swarmBestPosition)
    # for demo, velocity will be bound in (-.01, .01)
    velocity = [vector([randomBound(-.01,.01) for v in xranges]) for p in range(n)]

    addParticlePath(f, position)

    iteration = 0
    delta = Infinity
    while iteration < T:
        num_converged = 0
        for i in range(n):
            r_p, r_g = random(), random()
            # Update velocity
            # velocity <- weighted avg( previous_velocity, random()*(myBest - myCurrent), random()*(globalBest - myCurrent) )
            velocity[i] = omega*velocity[i] + phi_p*r_p*(particleBestPosition[i] - position[i]) + phi_g*r_g*(swarmBestPosition - position[i])
            # Update position
            prevValue = f(*position[i])
            position[i] += velocity[i]
            # Clamp positions
            for d, (lo, hi) in enumerate(xranges):
                position[i][d] = clamp(lo, position[i][d], hi)
            # Compare current position against best known
            if f(*position[i]) < f(*particleBestPosition[i]):
                particleBestPosition[i] = position[i]
                # Compare current position against swarm's best known
                if f(*position[i]) < f(*swarmBestPosition):
                    swarmBestPosition = position[i]
            delta = abs(f(*position[i]) - prevValue)
            if delta < epsilon:
                num_converged += 1
        # Exit on convergence
        if num_converged >= n:
            addParticlePath(f, position)
            break
        # Record trail
        if iteration % keyframes == 0:
            addParticlePath(f, position)
        iteration+=1

    print "Finished after {} iterations".format(iteration)

    return swarmBestPosition

print "Ready"
︡d4d3ccb3-bf89-4aa8-8985-fcc3e649bfaf︡{"stdout":"Ready\n"}︡
︠c61228e6-a412-4876-8683-d9349b208d82s︠
%var x
@interact
def _(f=sin(16*x)+x^2, omega=slider(0, 1, default=0.7, step_size=0.05), phi_p=slider(0, 1, default=0.2, step_size=0.05),
      phi_g=slider(0, 1, default=0.1, step_size=0.05), num_particles=slider(1, 20, default=10, step_size=1),
      limit_iterations=slider(50,1000,step_size=50,default=5000), epsilon=0.000001, keyframes=20):
    show(f)
    p = plot(f)
    print "Finding minima..."
    minima = pso(f, omega, phi_p, phi_g, (-1, 1), num_particles=num_particles, limit_iterations=limit_iterations, epsilon=epsilon, keyframes=keyframes)
    print "Done."
    p += point( list(minima) + [f(*minima)], size=100).plot()
    show(p)
    show("f({}) = {}".format(N(minima, digits=6), N(f(*minima), digits=6)))

    print "Generating animation..."
    a = animate(particlePaths, figsize=[5,5])
    print a
    a.save('animation2.mpeg', use_ffmpeg=True)
    print "Saved."
    show(a)
︡4c2e08c5-3985-42c0-8278-63329cddfb13︡{"interact":{"style":"None","flicker":false,"layout":[[["f",12,null]],[["omega",12,null]],[["phi_p",12,null]],[["phi_g",12,null]],[["num_particles",12,null]],[["limit_iterations",12,null]],[["epsilon",12,null]],[["keyframes",12,null]],[["",12,null]]],"id":"deeb045a-e8e1-47a2-99ae-69ff4af8ab5e","controls":[{"control_type":"input-box","default":"x^2 + sin(16*x)","label":"f","nrows":1,"width":null,"readonly":false,"submit_button":null,"var":"f","type":null},{"control_type":"slider","default":14,"var":"omega","width":null,"vals":["0.000000000000000","0.0500000000000000","0.100000000000000","0.150000000000000","0.200000000000000","0.250000000000000","0.300000000000000","0.350000000000000","0.400000000000000","0.450000000000000","0.500000000000000","0.550000000000000","0.600000000000000","0.650000000000000","0.700000000000000","0.750000000000000","0.800000000000000","0.850000000000000","0.900000000000000","0.950000000000000","1.00000000000000"],"animate":true,"label":"omega","display_value":true},{"control_type":"slider","default":4,"var":"phi_p","width":null,"vals":["0.000000000000000","0.0500000000000000","0.100000000000000","0.150000000000000","0.200000000000000","0.250000000000000","0.300000000000000","0.350000000000000","0.400000000000000","0.450000000000000","0.500000000000000","0.550000000000000","0.600000000000000","0.650000000000000","0.700000000000000","0.750000000000000","0.800000000000000","0.850000000000000","0.900000000000000","0.950000000000000","1.00000000000000"],"animate":true,"label":"phi_p","display_value":true},{"control_type":"slider","default":2,"var":"phi_g","width":null,"vals":["0.000000000000000","0.0500000000000000","0.100000000000000","0.150000000000000","0.200000000000000","0.250000000000000","0.300000000000000","0.350000000000000","0.400000000000000","0.450000000000000","0.500000000000000","0.550000000000000","0.600000000000000","0.650000000000000","0.700000000000000","0.750000000000000","0.800000000000000","0.850000000000000","0.900000000000000","0.950000000000000","1.00000000000000"],"animate":true,"label":"phi_g","display_value":true},{"control_type":"slider","default":9,"var":"num_particles","width":null,"vals":["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"],"animate":true,"label":"num_particles","display_value":true},{"control_type":"slider","default":19,"var":"limit_iterations","width":null,"vals":["50","100","150","200","250","300","350","400","450","500","550","600","650","700","750","800","850","900","950","1000"],"animate":true,"label":"limit_iterations","display_value":true},{"control_type":"input-box","default":"1.00000000000000e-6","label":"epsilon","nrows":1,"width":null,"readonly":false,"submit_button":null,"var":"epsilon","type":null},{"control_type":"input-box","default":20,"label":"keyframes","nrows":1,"width":null,"readonly":false,"submit_button":null,"var":"keyframes","type":null}]}}︡
︠9eda7ada-2298-4360-bafa-7aa635c0a590︠









