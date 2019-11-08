function [F,V,frame] = simulation(f,v,width,height,A)
use_adaptive_mesh_relaxation = true;
simulation_time = 1;
timescale_x = 1;
dmin = 0.05;
dt_u = 0.01;
T = 0;
Ts = zeros(100,1);
Frame(100) = struct('cdata',[],'colormap',[]);
frame=1;
F = cell(1,100);%assume at most 100 frames
V = cell(1,100);
F{frame}=f;
V{frame}=v;
starttime = tic;
%A stores the unique topology in the initial state
lastwarn('');
while T<=simulation_time && frame<=10
    looptime = tic;
    corsontime = tic;
    [f,v]=corson_dynamics(f,v,width,height,dt_u);
    Corsontime(frame)=toc(corsontime);
    t1checktime = tic;
    [f,v]=t1check(f,v,width,height,dmin,A);
    T1checktime(frame)=toc(t1checktime);
    updatetime = tic;
    [f,v] = update_simplex_parameter(f,v);
    Updatetime(frame) = toc(updatetime);
    movevertextime = tic;
    try
        Force = a_force([1:length(v)],f,v,width,height);
    catch
        warning('force calculation malfunction detected!');
        break
    end
    if use_adaptive_mesh_relaxation==true
        max_dx = max(sqrt(Force(:,1).^2 + Force(:,2).^2));
        if dmin./2/max_dx > simulation_time
            dt_x = dt_u;
        else
            sqrt(Force(:,1).^2 + Force(:,2).^2)
            dt_x = dmin./2./max_dx
        end
    end
    new_loc = loc(v(:))+dt_x.*Force./timescale_x;
    for i = 1:length(v)
        v(i).Loc = new_loc(i,:);
    end
    Movevertextime(frame)=toc(movevertextime);
    plottime = tic;
    plot_cell(f,v,width,height,true);
    plot_boundingbox(width,height);
    Plottime(frame)=toc(plottime);
    remainingtime = tic;
    Frame(frame) = getframe(gcf);
    hold off
    if get(gcf,'Number')>=10
        close('all');
    end
    frame = frame+1;
    F{frame}=f;
    V{frame}=v;
    if ~isempty(lastwarn)
        warning('polyshape construction malfunction detected!');
        break;
    end
    T=T+dt_x;
    Ts(frame)=dt_x;
    Remainingtime(frame)=toc(remainingtime);
    fprintf('T %.2f, Loop %.2f s\n',T,toc(looptime));
end
close('all');
figure
timestat = [mean(Corsontime),mean(T1checktime),mean(Updatetime),mean(Movevertextime),mean(Plottime),mean(Remainingtime)]
label={'corson','t1check','updatetopology','movevertex','plot','remaining'};
pie(timestat,label);
fprintf('Elapsed time for simulation = %f seconds. \n', toc(starttime));

reruns=1;                  % number of times movie is to play
fps=1;                     % frames per second
movie(Frame,reruns,fps)
figure
plot(Ts(1:frame),'o');
%save the movie
if ~exist('../Video/','dir')
    mkdir('../Video/');
end
vidObj = VideoWriter(strcat('../Video/',datestr(datetime(now,'ConvertFrom','datenum')),'.avi'),'Uncompressed AVI');
open(vidObj);
writeVideo(vidObj,Frame);
close(vidObj);
%save the plot
if ~exist('../Ts_plot/','dir')
    mkdir('../Ts_plot/');
end
savefig(gcf,strcat('../Ts_plot/',datestr(datetime(now,'ConvertFrom','datenum')),'.fig'));
end
    