classdef HaarFeatures
   properties
      featurePositions;
      featureType;
      featureAttributes;
   end
   methods
       function obj = HaarFeatures(attr)
           obj.featurePositions = attr(1:4,:);
           obj.featureType = attr(5,:);
           obj.featureAttributes = attr(6:14,:);
       end
       function result =HaarFeaturesCompute(obj, img, scale)
           
           responses = [];
           
           for i = 1:size(obj.featureType,2)
               r = round(obj.featurePositions(1,i)*scale);
               c = round(obj.featurePositions(2,i)*scale);
               w = round(obj.featurePositions(3,i)*scale);
               h = round(obj.featurePositions(4,i)*scale);
               response = 0;
               % img(r,c) + img(r+h,c+w) - img(r+h,c) - img(r,c+w)
               %? Rectangle 1: [r c ((winWidth/2) ? 1) (winHeight ? 1)]
               %? Rectangle 2: [r (c + winWidth/2) ((winWidth/2) ? 1) (winHeight ? 1)]
               if obj.featureType(i) == 1
                   rec1 = img(r,c) + img(r+h-1+1,c+round(w/2)-1+1) - img(r,c+round(w/2)-1+1) -img(r+h-1+1,c);
                   rec2 = img(r,c+round(w/2)) + img(r+h-1+1,c+w-1+1) - img(r,c+w-1+1) - img(r+h-1+1, c+round(w/2));
                   response = rec1 + rec2;
                   
               %? Rectangle 1: [r c (winWidth ? 1) ((winHeight/2) ? 1)]
               %? Rectangle 2: [(r + winHeight/2) c (winWidth ? 1) ((winHeight/2) ? 1)]
               elseif obj.featureType(i) == 2
                   rec1 = img(r,c) + img(r+round(h/2)-1+1,c+w-1+1) - img(r,c+w-1+1) -img(r+round(h/2)-1+1,c);
                   rec2 = img(r+round(h/2),c) + img(r+h-1+1,c+w-1+1) - ...
                       img(r+round(h/2),c+w-1+1) - img(r+h-1+1,c); %%mqybe wrong c+w-1
                   response = rec1 + rec2;
               %? Rectangle 1: [r c ((winWidth/3) ? 1) (winHeight ? 1)]
               %? Rectangle 2: [r (c + (winWidth/3)) ((winWidth/3) ? 1) (winHeight ? 1)]
               %? Rectangle 3: [r (c + ((2 ? winWidth)/3)) ((winWidth/3) ? 1) (winHeight ? 1)]
               %? Feature response: Rectangle1 ? Rectangle2 + Rectangle3
               elseif obj.featureType(i) == 3
                   rec1 = img(r,c) + img(r+h-1+1,c+round(w/3)-1+1) - ...
                       img(r,c+round(w/3)-1+1) -img(r+h-1+1,c);
                   rec2 = img(r,c+round(w/3)) + img(r+h-1+1,c+round(2*w/3)-1+1) ...
                       - img(r,c+round(2*w/3)-1+1) - img(r+h-1+1, c+round(w/3));
                   rec3 = img(r,c+round(2*w/3)) + img(r+h-1+1,c+w-1+1) - img(r,c+w-1+1) ...
                       - img(r+h-1+1, c+round(2*w/3));
                   response = rec1 - rec2 + rec3;

               %? Rectangle 1: [r c (winWidth ? 1) ((winHeight/3) ? 1)]
               %? Rectangle 2: [(r + (winHeight/3)) c (winWidth ? 1) ((winHeight/3) ? 1)]
               %? Rectangle 3: [(r + ((2 ? winHeight)/3)) c (winWidth ? 1) ((winHeight/3) ? 1)]
               %? Feature response: Rectangle1 ? Rectangle2 + Rectangle3
               elseif obj.featureType(i) == 4
                   rec1 = img(r,c) + img(r+round(h/3)-1+1,c+w-1+1) - img(r,c+w-1+1) -img(r+round(h/3)-1+1,c);
                   rec2 = img(r+round(h/3),c) + img(r+round(2*h/3)-1+1,c+w-1+1) - ...
                       img(r+round(h/3),c+w-1+1) - img(r+round(2*h/3)-1+1,c);
                   rec3 = img(r+round(2*h/3),c) + img(r+h-1+1,c+w-1+1) - img(r+round(2*h/3),c+w-1+1) ...
                       - img(r+h-1+1,c);
                   response = rec1 - rec2 + rec3;

               %? Rectangle 1: [r c (winWidth/2 ? 1) (winHeight/2 ? 1)]
               %? Rectangle 2: [r (c + winWidth/2) (winWidth/2 ? 1) (winHeight/2 ? 1)]
               %? Rectangle 3: [(r + winHeight/2) c (winW idth/2 ? 1) (winHeight/2 ? 1)]
               %? Rectangle 4: [(r+winHeight/2) (c+winW idth/2) (winW idth/2?1) (winHeight/2?1)]
               %? Feature response: Rectangle1 ? Rectangle2 + Rectangle3 ? Rectangle4
               elseif obj.featureType(i) == 5
                   rec1 = img(r,c) + img(r+round(h/2)-1+1,c+round(w/2)-1+1) - ...
                       img(r,c+round(w/2)-1+1) -img(r+round(h/2)-1+1,c);
                   rec2 = img(r,c+round(w/2)) + img(r+round(h/2)-1+1,c+w-1+1) - img(r,c+w-1+1) ...
                       - img(r+round(h/2)-1+1, c+round(w/2));
                   rec3 = img(r+round(h/2),c) + img(r+h-1+1,c+round(w/2)-1+1) - img(r+h-1+1,c) ...
                       - img(r+round(h/2),c+round(w/2)-1+1);
                   rec4 = img(r+round(h/2),c+round(w/2)) + img(r+h-1+1,c+w-1+1) - img(r+h-1+1,c+round(w/2)) ...
                       - img(r+round(h/2),c+w-1+1);
                   response = rec1 - rec2 + rec3 - rec4;
               end
               responses = [responses, response];
           end
           %? (mean ? abs(mean ? minPos) ? (R ? 5)/50) <= t <= (mean + abs(maxPos ? mean) ?(R ? 5)/50)
           mean = obj.featureAttributes(1,:);
           maxPos = obj.featureAttributes(3,:);
           minPos = obj.featureAttributes(4,:);
           R = obj.featureAttributes(5,:);
           
           lowThr = mean - abs(mean-minPos) .* (R-5)/50;
           highThr = mean + abs(maxPos-mean) .* (R-5)/50;
           
           result = (lowThr <= responses) & (responses <= highThr);
           result = sum(result);
       end
   end
end