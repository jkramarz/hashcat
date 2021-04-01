/**
 * Author......: See docs/credits.txt
 * License.....: MIT
 */

//#define NEW_SIMD_CODE

#ifdef KERNEL_STATIC
#include "inc_vendor.h"
#include "inc_types.h"
#include "inc_platform.cl"
#include "inc_common.cl"
#include "inc_scalar.cl"
#include "inc_hash_md5.cl"
#endif

KERNEL_FQ void m29800_mxx (KERN_ATTR_BASIC ())
{
  /**
   * modifier
   */

  const u64 gid = get_global_id (0);

  if (gid >= gid_max) return;

  /**
   * base
   */

  md5_ctx_t ctx0;

  md5_init (&ctx0);

  md5_update_global (&ctx0, pws[gid].i, pws[gid].pw_len);

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos++)
  {
    md5_ctx_t ctx1 = ctx0;

    md5_update_global (&ctx1, combs_buf[il_pos].i, combs_buf[il_pos].pw_len);

    md5_final (&ctx1);

    const u32 a = ctx1.h[0];
    const u32 b = ctx1.h[1] & 0x000000ff;

    md5_ctx_t ctx;

    md5_init (&ctx);

    u32x _w[64] = { 0 };

    _w[0] = a;
    _w[1] = b;

    md5_update_vector (&ctx, _w, 5);

    md5_final (&ctx);

    const u32 r0 = ctx.h[DGST_R0];
    const u32 r1 = ctx.h[DGST_R1] & 0x000000ff;
    const u32 r2 = 0;
    const u32 r3 = 0;

    COMPARE_M_SCALAR (r0, r1, r2, r3);
  }
}

KERNEL_FQ void m29800_sxx (KERN_ATTR_BASIC ())
{
  /**
   * modifier
   */

  const u64 gid = get_global_id (0);

  if (gid >= gid_max) return;

  /**
   * digest
   */

  const u32 search[4] =
  {
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R0],
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R1],
    0,
    0
  };

  /**
   * base
   */

  md5_ctx_t ctx0;

  md5_init (&ctx0);

  md5_update_global (&ctx0, pws[gid].i, pws[gid].pw_len);

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos++)
  {
    md5_ctx_t ctx1 = ctx0;

    md5_update_global (&ctx1, combs_buf[il_pos].i, combs_buf[il_pos].pw_len);

    md5_final (&ctx1);

    const u32 a = ctx1.h[0];
    const u32 b = ctx1.h[1] & 0x000000ff;

    md5_ctx_t ctx;

    md5_init (&ctx);

    u32x _w[64] = { 0 };

    _w[0] = a;
    _w[1] = b;

    md5_update_vector (&ctx, _w, 5);

    md5_final (&ctx);

    const u32 r0 = ctx.h[DGST_R0];
    const u32 r1 = ctx.h[DGST_R1] & 0x000000ff;
    const u32 r2 = 0;
    const u32 r3 = 0;

    COMPARE_S_SCALAR (r0, r1, r2, r3);
  }
}