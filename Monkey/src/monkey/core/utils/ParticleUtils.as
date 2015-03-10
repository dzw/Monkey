package monkey.core.utils {
	
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import monkey.core.entities.particles.ParticleSystem;

	public class ParticleUtils {
		
		
		/**
		 * 粒子系统运行期关键帧数据生成器 
		 * @param maxLifetime	最大生命周期时间
		 * @param speedX		x轴速度关键帧
		 * @param speedY		y轴速度关键帧
		 * @param speedZ		z轴速度关键帧
		 * @param axisX			x轴旋转关键帧
		 * @param axisY			y轴旋转关键帧
		 * @param axisZ			z轴旋转关键帧
		 * @param size			尺寸关键帧
		 * @return 
		 * 
		 */		
		public static function GeneratelifetimeBytes(maxLifetime : Number, speedX : Linears, speedY : Linears, speedZ : Linears, axisX : Linears, axisY : Linears, axisZ : Linears, size : Linears) : ByteArray {
			var bytes  : ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			var step: Number = 1 / (ParticleSystem.MAX_KEY_NUM - 1);
			var t	: Number = maxLifetime / (ParticleSystem.MAX_KEY_NUM - 1);		
			var ret : Vector3D = new Vector3D();
			// 旋转
			for (i = 0; i < ParticleSystem.MAX_KEY_NUM; i++) {
				bytes.writeFloat(axisX.getY(i * step));
				bytes.writeFloat(axisY.getY(i * step));
				bytes.writeFloat(axisZ.getY(i * step));
				bytes.writeFloat(deg2rad(360));
			}
			// 缩放
			for (i = 0; i < ParticleSystem.MAX_KEY_NUM; i++) {
				bytes.writeFloat(size.getY(i * step));
				bytes.writeFloat(size.getY(i * step));
				bytes.writeFloat(size.getY(i * step));
				bytes.writeFloat(size.getY(i * step));
			}
			// 位移
			for (var i:int = 0; i < ParticleSystem.MAX_KEY_NUM; i++) {
				var x : Number = uniformly(speedX.getY(step * i), speedX.getY(step * i + step), t);
				var y : Number = uniformly(speedY.getY(step * i), speedY.getY(step * i + step), t);
				var z : Number = uniformly(speedZ.getY(step * i), speedZ.getY(step * i + step), t);
				bytes.writeFloat(ret.x);
				bytes.writeFloat(ret.y);
				bytes.writeFloat(ret.z);
				bytes.writeFloat(maxLifetime);
				ret.x += x;
				ret.y += y;
				ret.z += z;
			}
			return bytes;
		}
		
		private static function uniformly(v0 : Number, vt : Number, t : Number) : Number {
			var a : Number = (vt - v0) / t;
			var s : Number = v0 * t + 0.5 * a * t * t;
			return s;
		}
		
	}
}
