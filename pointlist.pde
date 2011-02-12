import java.util.ArrayList;
import java.util.Iterator;

/**
 * This class enables group/set operations of multiple Vec3D's at once.
 * 
 * @author Karsten Schmidt
 *
 */
public class PointList extends ArrayList {
        
        public PointList() {
                super();
        }
        
        public PointList addSelf(Vec3D offset) {
                Iterator i=iterator();
                while(i.hasNext()) {
                        ((Vec3D)i.next()).addSelf(offset);
                }
                return this;
        }
        
        public PointList subSelf(Vec3D offset) {
                Iterator i=iterator();
                while(i.hasNext()) {
                        ((Vec3D)i.next()).subSelf(offset);
                }
                return this;
        }
        
        public PointList scaleSelf(Vec3D factor) {
                Iterator i=iterator();
                while(i.hasNext()) {
                        ((Vec3D)i.next()).scaleSelf(factor);
                }
                return this;
        }
        
        public PointList scaleSelf(float factor) {
                Iterator i=iterator();
                while(i.hasNext()) {
                        ((Vec3D)i.next()).scaleSelf(factor);
                }
                return this;
        }
}